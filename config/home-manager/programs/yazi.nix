{ pkgs, ... }:
let
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "e95c7b384e7b0a9793fe1471f0f8f7810ef2a7ed";
    hash = "sha256-TUS+yXxBOt6tL/zz10k4ezot8IgVg0/2BbS8wPs9KcE=";
  };
in
{
  home.packages = with pkgs; [
    yazi
    trash-cli
  ];
  programs.yazi = {
    enable = true;
    # package = yazi;  # LATEST VERSION
    enableZshIntegration = false;
    enableBashIntegration = false;

    plugins = {
      jump-to-char = "${yazi-plugins}/jump-to-char.yazi";

      # nurl helps alot
      dupes = pkgs.fetchFromGitHub {
        owner = "mshnwq";
        repo = "dupes.yazi";
        rev = "main";
        hash = "sha256-2kfjQB8v29VrHbzNzmkZOnOQn+R92rryxcP8YXFKCHc=";
      };

      relative-motions = pkgs.fetchFromGitHub {
        owner = "dedukun";
        repo = "relative-motions.yazi";
        rev = "a603d9e";
        hash = "sha256-9i6x/VxGOA3bB3FPieB7mQ1zGaMK5wnMhYqsq4CvaM4=";
      };

      bookmarks = pkgs.fetchFromGitHub {
        owner = "dedukun";
        repo = "bookmarks.yazi";
        rev = "9ef1254";
        hash = "sha256-GQFBRB2aQqmmuKZ0BpcCAC4r0JFKqIANZNhUC98SlwY=";
      };

      yamb = pkgs.fetchFromGitHub {
        owner = "h-hg";
        repo = "yamb.yazi";
        rev = "22af0033be18eead7b04c2768767d38ccfbaa05b";
        hash = "sha256-NMxZ8/7HQgs+BsZeH4nEglWsRH2ibAzq7hRSyrtFDTA=";
      };

      projects = pkgs.fetchFromGitHub {
        owner = "MasouShizuka";
        repo = "projects.yazi";
        rev = "a5e33db284ab580de7b549e472bba13a5ba7c7b9";
        hash = "sha256-4VD1OlzGgyeB1jRgPpI4aWnOCHNZQ9vhh40cbU80Les=";
      };

      restore = pkgs.fetchFromGitHub {
        owner = "boydaihungst";
        repo = "restore.yazi";
        rev = "2a2ba2fbaee72f88054a43723becf66c3cfb892e";
        hash = "sha256-FqvQuKNH3jjXQ/7N7MsUsOoh9DTreZTjpdQ4lrr2iLk=";
      };
    };
  };
}
