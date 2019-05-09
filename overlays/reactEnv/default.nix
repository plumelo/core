self: super:
{
  react = with super; buildEnv {
    name  = "react";
    paths = [
      nodejs-10_x
      (yarn.override { nodejs = nodejs-10_x; })
      graphviz
    ];
  };
}
