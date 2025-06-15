{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.kanata = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use kanata";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.kanata.enable {
      /*
      services.kanata = {
        enable = true;
        keyboards = {
          internalKeyboard = {
            extraDefCfg = "process-unmapped-keys yes";
            config = ''
              (defsrc
                esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
                grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
                tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
                caps a    s    d    f    g    h    j    k    l    ;    '    ret
                lsft z    x    c    v    b    n    m    ,    .    /    rsft
                lctl lmet lalt           spc            ralt rmet rctl
              )

              (defvar
                tap-time 150
                hold-time 200
              )

              (defalias
                caps (tap-hold 100 100 esc lctl)
                a (multi f24 (tap-hold-press $tap-time $hold-time a lmet))
                s (multi f24 (tap-hold-press $tap-time $hold-time s lalt))
                d (multi f24 (tap-hold-press $tap-time $hold-time d lsft))
                f (multi f24 (tap-hold-press $tap-time $hold-time f lctl))
                j (multi f24 (tap-hold $tap-time $hold-time j rctl))
                k (multi f24 (tap-hold $tap-time $hold-time k rsft))
                l (multi f24 (tap-hold $tap-time $hold-time l ralt))
                ; (multi f24 (tap-hold $tap-time $hold-time ; rmet))

                oe (fork (unicode ö) (unicode Ö) (lsft rsft))
                ae (fork (unicode ä) (unicode Ä) (lsft rsft))
                ue (fork (unicode ü) (unicode Ü) (lsft rsft))
                se (fork (unicode ß) (unicode ẞ) (lsft rsft))

                euro (unicode €)
                pound (unicode £)

                base (layer-switch base)
                gr (layer-switch gr)
                sy (layer-switch sy)

                g (multi f24 (tap-hold $tap-time $hold-time g (layer-while-held gr)))
                h (multi f24 (tap-hold $tap-time $hold-time h (layer-while-held gr)))

                b (multi f24 (tap-hold $tap-time $hold-time b (layer-while-held sy)))
                n (multi f24 (tap-hold $tap-time $hold-time n (layer-while-held sy)))
              )

              (deflayer base
                XX   f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
                grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
                tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
                esc  @a   @s   @d   @f   g    h    @j   @k   @l   @;    '    ret
                lsft z    x    c    v    b    n    m    ,    .    /    rsft
                lctl lmet lalt           spc            ralt rmet rctl
              )

              (deflayer gr
                XX   f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
                grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
                tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
                esc  @a   @s   @d   @f   g    h    @j   @k   @l   @;    '    ret
                lsft z    x    c    v    b    n    m    ,    .    /    rsft
                lctl lmet lalt           spc            ralt rmet rctl
              )

              (deflayer sy
                XX   f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
                grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
                tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
                esc  @a   @s   @d   @f   g    h    @j   @k   @l   @;   '    ret
                lsft z    x    c    v    b    n    m    ,    .    /    rsft
                lctl lmet lalt           spc            ralt rmet rctl
              )
            '';
          };
        };
      };
      */

      /*
        services.kanata = {
          enable = false;
          keyboards = {
            "logi".config = ''
      (defsrc
        grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
        tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
        caps a    s    d    f    g    h    j    k    l    ;    '    ret
        lsft z    x    c    v    b    n    m    ,    .    /    rsft
        lctl lmet lalt           spc            ralt rmet rctl
      )

      (defvar
        tap-time 150
        hold-time 200
      )

      (defalias
        a (multi f24 (tap-hold $tap-time $hold-time a lmet))
        s (multi f24 (tap-hold $tap-time $hold-time s lalt))
        d (multi f24 (tap-hold $tap-time $hold-time d lsft))
        f (multi f24 (tap-hold $tap-time $hold-time f lctl))
        j (multi f24 (tap-hold $tap-time $hold-time j rctl))
        k (multi f24 (tap-hold $tap-time $hold-time k rsft))
        l (multi f24 (tap-hold $tap-time $hold-time l ralt))
        ; (multi f24 (tap-hold $tap-time $hold-time ; rmet))
        oe (fork (unicode ö) (unicode Ö) (lsft rsft))
        ae (fork (unicode ä) (unicode Ä) (lsft rsft))
        ue (fork (unicode ü) (unicode Ü) (lsft rsft))
        se (fork (unicode ß) (unicode ẞ) (lsft rsft))
        euro (unicode €)
        pound (unicode £)
        main (layer-switch main)
        gr (layer-switch gr)
        sy (layer-switch symbol)
        g (multi f24 (tap-hold $tap-time $hold-time g (layer-while-held gr)))
        h (multi f24 (tap-hold $tap-time $hold-time h (layer-while-held gr)))

        b (multi f24 (tap-hold $tap-time $hold-time b (layer-while-held sy)))
        n (multi f24 (tap-hold $tap-time $hold-time n (layer-while-held sy)))
      )

      (deflayer main
        XX      XX      XX      XX      XX      XX      XX      XX      XX      XX      XX      XX      XX      bspc
        tab     q       w       e       r       t       y       u       i       o       p       XX      XX      XX
        esc     @a      @s      @d      @f      @g      @h      @j      @k      @l      @;      XX      ret
        XX      z       x       c       v       b       n       m       ,       .       /       XX
        XX      XX      XX                      spc                     XX      XX      XX
      )

      (deflayer gr
        XX      XX      XX      XX      XX      XX      XX      XX      XX      XX      XX      XX      XX       del
        XX      ~       `       @euro   #       &       ^       @ue     XX      @oe     |       XX      XX       XX
        main    @ae     @se     -       /       @gr     @gr     \       '       "       _       XX      XX
        XX      (       )       [       ]       {       }       <       >       !       @       XX
        XX      XX      XX                      XX                      $       @euro   @pound
      )

      (deflayer symbol
        XX      XX      XX      XX      XX      XX      XX      XX      XX      XX      XX      XX      XX       XX
        XX      1       2       3       4       5       6       7       8       9       0       XX      XX       XX
        main    +       -       *       /       =       left    down    up      right   %       XX      XX
        XX      XX      XX      XX      XX      @sy     @sy     XX      XX      XX      XX      XX
        XX      XX      XX                      XX                      XX      XX      XX
      )
            '';
          };
        };
      */
    })
  ];
}
