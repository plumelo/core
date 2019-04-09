self: super:
with super;
{
  yarn = yarn.override {
    nodejs = nodejs-10_x;
  };
}
