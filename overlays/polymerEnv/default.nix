self: super:
{
  polymer = with super; buildEnv {
    name  = "polymer";
    paths = [
      firefox
      nodejs-10_x
      (writeShellScriptBin "yarn" ''
        export LAUNCHPAD_CHROME=${google-chrome}/bin/google-chrome-stable
        exec -a "$0" ${yarn}/bin/yarn "$@"
      '')
      (writeShellScriptBin "link-chromedriver" ''
        ln -sfnv "${chromedriver}/bin/chromedriver" "$(find "./node_modules" -path '**/chromedriver/*-chromedriver')"
        ln -sfnv "${sauce-connect}/bin/sc" "$(find "./node_modules" -path '**/sauce-connect-launcher/sc/sc-*-linux/bin/sc')"
      '')
    ];
  };
}
