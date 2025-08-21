#!/usr/bin/env bash
# Explicit nix-shell wrapper for keyboard shortcuts

# Check if we're running with nix-shell, if not, re-exec with nix-shell
if [ -z "${IN_NIX_SHELL:-}" ]; then
    exec nix-shell -p openai-whisper ffmpeg wtype libnotify pulseaudio --run "$0 $*"
fi

set -euo pipefail

# Setup environment for keyboard shortcut execution
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
export PULSE_SERVER="${PULSE_SERVER:-unix:${XDG_RUNTIME_DIR}/pulse/native}"
export PULSE_RUNTIME_PATH="${PULSE_RUNTIME_PATH:-${XDG_RUNTIME_DIR}/pulse}"

SCRIPT_NAME="voice-type"
PID_FILE="/tmp/${SCRIPT_NAME}.pid"
AUDIO_FILE="/tmp/${SCRIPT_NAME}_recording.wav"
WHISPER_MODEL="large"  # Options: tiny, base, small, medium, large
LOG_FILE="/tmp/${SCRIPT_NAME}.log"

# Function to detect available audio input device
detect_audio_device() {
    # Try to find available audio sources
    if command -v pactl >/dev/null 2>&1; then
        # Use pactl to find default source
        DEFAULT_SOURCE=$(pactl get-default-source 2>/dev/null || echo "")
        if [ -n "$DEFAULT_SOURCE" ]; then
            echo "$DEFAULT_SOURCE"
            return 0
        fi

        # Fallback: get first available source
        FIRST_SOURCE=$(pactl list sources short 2>/dev/null | head -1 | cut -f2)
        if [ -n "$FIRST_SOURCE" ]; then
            echo "$FIRST_SOURCE"
            return 0
        fi
    fi

    # Final fallback
    echo "default"
}

# Function to start recording
start_recording() {
    echo "Starting voice recording..." | tee -a "$LOG_FILE"

    # Detect audio device
    AUDIO_DEVICE=$(detect_audio_device)
    echo "Using audio device: $AUDIO_DEVICE" | tee -a "$LOG_FILE"

    # Start recording with detected device
    ffmpeg -f pulse -i "$AUDIO_DEVICE" -acodec pcm_s16le -ar 16000 -ac 1 "$AUDIO_FILE" 2>>"$LOG_FILE" &
    RECORDING_PID=$!

    # Store the PID for later cleanup
    echo "$RECORDING_PID" > "$PID_FILE"

    # Log recording start
    echo "Recording started with PID: $RECORDING_PID using device: $AUDIO_DEVICE" | tee -a "$LOG_FILE"
}

# Function to stop recording and transcribe
stop_recording_and_transcribe() {
    if [ -f "$PID_FILE" ]; then
        RECORDING_PID=$(cat "$PID_FILE")

        echo "Stopping recording..." | tee -a "$LOG_FILE"

        # Stop ffmpeg gracefully
        kill -TERM "$RECORDING_PID" 2>/dev/null || true
        wait "$RECORDING_PID" 2>/dev/null || true

        # Clean up PID file
        rm -f "$PID_FILE"

        # Wait a moment for ffmpeg to finish writing the file
        sleep 1

        # Check if audio file exists and has content
        if [ -f "$AUDIO_FILE" ] && [ -s "$AUDIO_FILE" ]; then
            AUDIO_SIZE=$(stat -f%z "$AUDIO_FILE" 2>/dev/null || stat -c%s "$AUDIO_FILE" 2>/dev/null || echo "0")
            echo "Audio file size: $AUDIO_SIZE bytes" | tee -a "$LOG_FILE"
            echo "Transcribing audio..." | tee -a "$LOG_FILE"

            # Transcribe using Whisper CLI
            echo "Running whisper command: whisper \"$AUDIO_FILE\" --language English --fp16 False --model \"$WHISPER_MODEL\" --output_format txt --output_dir /tmp --verbose False" >> "$LOG_FILE"

            # Generate temporary filename for output
            AUDIO_BASENAME=$(basename "$AUDIO_FILE" .wav)
            TXT_FILE="/tmp/${AUDIO_BASENAME}.txt"

            # Run whisper and capture both stdout and stderr
            whisper "$AUDIO_FILE" --language English --fp16 False --model "$WHISPER_MODEL" --output_format txt --output_dir /tmp --verbose False >> "$LOG_FILE" 2>&1
            WHISPER_EXIT_CODE=$?

            # Read transcript from generated file
            if [ -f "$TXT_FILE" ] && [ -s "$TXT_FILE" ]; then
                TRANSCRIPT=$(cat "$TXT_FILE" | tr -d '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                rm -f "$TXT_FILE"  # Clean up the txt file
            else
                TRANSCRIPT=""
                echo "Whisper output file $TXT_FILE not found or empty" >> "$LOG_FILE"
            fi

            if [ $WHISPER_EXIT_CODE -eq 0 ] && [ -n "$TRANSCRIPT" ]; then
                echo "Transcription: $TRANSCRIPT" | tee -a "$LOG_FILE"

                # Type the transcribed text using wtype (Wayland-compatible)
                echo "$TRANSCRIPT" | wtype -
                echo "Text typed successfully" | tee -a "$LOG_FILE"

            else
                echo "Transcription failed or empty (exit code: $WHISPER_EXIT_CODE)" | tee -a "$LOG_FILE"
                notify-send "Voice Type" "Transcription failed" 2>/dev/null || true
            fi
        else
            echo "No audio file found or file is empty" | tee -a "$LOG_FILE"
            if [ -f "$AUDIO_FILE" ]; then
                echo "Audio file exists but is empty" | tee -a "$LOG_FILE"
            else
                echo "Audio file does not exist" | tee -a "$LOG_FILE"
            fi
            echo "Check $LOG_FILE for ffmpeg errors" | tee -a "$LOG_FILE"
            notify-send "Voice Type" "Recording failed - check logs" 2>/dev/null || true
        fi

        # Clean up audio file
        rm -f "$AUDIO_FILE"
    else
        echo "No recording in progress" | tee -a "$LOG_FILE"
    fi
}

# Main logic
if [ -f "$PID_FILE" ]; then
    # Recording is in progress, stop it
    stop_recording_and_transcribe
else
    # No recording in progress, start one
    start_recording
fi