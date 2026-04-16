{ ... }:
{
  services.homepage-dashboard.settings = {
    title = "Admin Dashboard";
    description = "Test";

    # Theme & appearance
    theme = "dark";       # "dark" | "light"
    color = "yellow";      # slate, gray, zinc, neutral, stone, amber, yellow,
                          # lime, green, emerald, teal, cyan, sky, blue,
                          # indigo, violet, purple, fuchsia, pink, rose, red, white

    # Background image (URL or path)
    # background = "https://images.unsplash.com/photo-1502790671504-542ad42d5189?auto=format&fit=crop&w=2560&q=80";
    # Advanced background with filters:
    # background = {
    #   image = "/images/background.png";
    #   blur = "sm";        # sm, md, xl... (tailwind backdrop-blur)
    #   saturate = 50;      # 0, 50, 100...
    #   brightness = 50;    # 0, 50, 75...
    #   opacity = 50;       # 0-100
    # };

    # favicon = "https://www.google.com/favicon.ico";

    # Card blur (incompatible with background blur/saturate/brightness)
    # cardBlur = "sm";

    # Header style: "underlined" | "boxed" | "clean" | "boxedWidgets"
    headerStyle = "underlined";

    # Icon style: "theme" | (omit for default gradient)
    # iconStyle = "theme";

    # Link target: "_blank" | "_self" | "_top"
    target = "_blank";

    # Language (en, de, fr, es, zh-Hans, zh-Hant, etc.)
    language = "en";

    # Layout
    fullWidth = false;
    # maxGroupColumns = 4;         # max 8; default 4 services, 6 bookmarks
    # maxBookmarkGroupColumns = 6;
    disableCollapse = false;
    groupsInitiallyCollapsed = false;
    useEqualHeights = false;

    # layout = {
    #   Media = {
    #     style = "row";
    #     columns = 4;
    #     header = true;
    #     initiallyCollapsed = false;
    #     useEqualHeights = false;
    #     # icon = "home-assistant.png";
    #     # tab = "Main";
    #   };
    # };

    # Quick Launch (type anywhere on the page to trigger)
    quicklaunch = {
      searchDescriptions = true;
      hideInternetSearch = false;
      showSearchSuggestions = true;
      hideVisitURL = false;
      provider = "google"; # google, duckduckgo, bing, baidu, brave, custom
      # mobileButtonPosition = "bottom-right"; # top-left | top-right | bottom-left | bottom-right
    };

    # # PWA
    # # startUrl = "/";
    # pwa = {
    #   icons = [
    #     {
    #       src = "/icons/icon-192x192.png";
    #       type = "image/png";
    #       sizes = "192x192";
    #     }
    #     {
    #       src = "/icons/icon-512x512.png";
    #       type = "image/png";
    #       sizes = "512x512";
    #     }
    #   ];
      shortcuts = [
        {
          name = "Home";
          url = "/";
        }
        # {
        #   name = "Media";
        #   url = "/#media";
        # }
      ];
    };

    # Docker / service status
    showStats = false;
    # statusStyle = "dot"; # "" (default) | "dot" | "basic"

    # Bookmarks global display style
    # bookmarksStyle = "icons";

    # Misc
    hideVersion = false;
    disableUpdateCheck = false;
    disableIndexing = false;
    hideErrors = false;
    # instanceName = "public";  # for multi-instance docker discovery
    # logpath = "/config/logs";
    # base = "http://host.local/homepage";  # only needed behind some reverse proxies
    };

    # Shared API provider keys (used by widgets)
    # providers = {
    #   openweathermap = "YOUR_API_KEY";
    #   finnhub = "YOUR_API_KEY";
    # };
}

