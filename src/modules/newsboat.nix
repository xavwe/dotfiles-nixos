{
  inputs,
  lib,
  config,
  pkgs,
  home-manager,
  ...
}: {
  options.modules.newsboat = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use newsboat";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.newsboat.enable {
      home-manager.users.nu = {...}: {
        programs.newsboat = {
          enable = true;
          urls = [
            # Vaxry - blog - en
            {
              tags = [
                "tech"
                "blog"
              ];
              url = "https://blog.vaxry.net/feed";
            }
            # Simon Willison - blog - en
            {
              tags = [
                "tech"
                "blog"
              ];
              url = "https://simonwillison.net/atom/everything/";
            }
            # Drew DeVault - blog - en
            {
              tags = [
                "tech"
                "blog"
              ];
              url = "https://drewdevault.com/blog/index.xml";
            }
            # Ruby Granger - YouTube - en
            {
              tags = [
                "study"
                "video"
              ];
              url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC6a8lp6vaCMhUVXPyynhjUA";
            }
            # UnJaded Jade - YouTube - en
            {
              tags = [
                "study"
                "video"
              ];
              url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC4-uObu-mfafJyxxZFEwbvQ";
            }
            # Luke Smith - blog - en
            {
              tags = [
                "tech"
                "blog"
              ];
              url = "https://lukesmith.xyz/index.xml";
            }
            # Sami - YouTube - en
            {
              tags = [
                "tech"
                "video"
              ];
              url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCNFFrCzvkeF4CIAkE5sv3WA";
            }
            # Philipp Lackner - YouTube - en
            {
              tags = [
                "tech"
                "video"
              ];
              url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCKNTZMRHPLXfqlbdOI7mCkg";
            }
            # The Engineering Mindset - YouTube - en
            {
              tags = [
                "engineering"
                "video"
              ];
              url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCk0fGHsCEzGig-rSzkfCjMw";
            }
            # Beyond Fireship - YouTube - en
            {
              tags = [
                "tech"
                "video"
              ];
              url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC2Xd-TjJByJyK2w1zNwY0zQ";
            }
            # ThePrimeagen - YouTube - en
            {
              tags = [
                "tech"
                "video"
              ];
              url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC8ENHE5xdFSwx71u3fDH5Xw";
            }
            # David Kriesel - blog - de
            {
              tags = [
                "tech"
                "blog"
              ];
              url = "https://www.dkriesel.com/feed.php?linkto=current&content=html&mode=blogtng&blog=blog-de";
            }
          ];
          extraConfig = ''
            color background          color7     color0
            color listnormal          color240      color0
            color listnormal_unread   color7      color0
            color listfocus           color240   color8
            color listfocus_unread    color7   color8
            color info                color8     color0
            color article             color223   color0

            # highlights
            highlight article "^(Feed|Link):.*$" color11 default bold
            highlight article "^(Title|Date|Author):.*$" color11 default bold
            highlight article "https?://[^ ]+" color2 default underline
            highlight article "\\[[0-9]+\\]" color2 default bold
            highlight article "\\[image\\ [0-9]+\\]" color2 default bold
            highlight feedlist "^─.*$" color6 color6 bold
          '';
        };
      };
    })
  ];
}