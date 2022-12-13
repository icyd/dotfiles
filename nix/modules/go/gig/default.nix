{ lib, buildGo118Module, fetchFromGitHub }:
let
  owner = "shihanng";
  repo = "gig";
in buildGo118Module rec {
    pname = "gig";
    version = "0.8.3";
    src = fetchFromGitHub {
      inherit owner repo;

      rev = "v${version}";
      sha256 = "0xa77912h6i0zlsg2gr9dw1sp1y6yzrmh2hcjq8q3ih5207g7x77";
    };
    vendorSha256 = "sha256-yFvdqZDaGas/gwuEhtIpCSAKQBMJqiT2hIZyVL9ZSp0=";
}
