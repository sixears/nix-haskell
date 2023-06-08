{
  description = "basic setup for haskell/ghci";

  inputs = {
    nixpkgs.url     = github:nixos/nixpkgs/be44bf67; # nixos-22.05 2022-10-15
    flake-utils.url = github:numtide/flake-utils/c0e246b9;
# hpkgs1.url = path:/home/martyn/src/hpkgs1;
    hpkgs1.url      = github:sixears/hpkgs1/r0.0.16.0;
  };

  outputs = { self, nixpkgs, flake-utils, hpkgs1 }:
    # many things don't work on, say, darwin
    flake-utils.lib.eachSystem ["x86_64-linux"] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        hpkgs = hpkgs1.packages.${system};
        hlib  = hpkgs1.lib.${system};
      in
        rec {
          packages = flake-utils.lib.flattenTree (with pkgs; {
            default = hlib.ghcWithHoogle (haskellPackages:
              builtins.attrValues hpkgs ++
              (with haskellPackages;
                     [
                       aeson ansi-wl-pprint base-unicode-symbols
                       # broken in nixpkgs as of 2021-08-18 5ebd941b75a8
                       # containers-unicode-symbols
##                       criterion data-default deepseq
##                       deepseq dhall diagrams Diff doctest exceptions filelock
##                       finite-typelits formatting freer genvalidity
##                       genvalidity-bytestring genvalidity-hspec
##                       genvalidity-property genvalidity-text ghc-typelits-extra
##                       hostaddress hostname http-client HUnit inflections keys
##                       lens ListLike logging-effect markdown-unlit monad-loops
##                       mono-traversable network-ip nonempty-containers
##                       optparse-applicative parsec parsers path pipes QuickCheck
##                       rainbow random range regex-applicative
##                       regex-pcre regex-with-pcre rio safe scientific shake
##                       shelly split streaming strings SVGFonts tagsoup tasty
##                       tasty-hspec tasty-hunit tasty-quickcheck
##                       temporary terminal-size text
##                       text-format text-icu th-lift-instances timers trifecta
##                       unordered-containers validity vector xmonad-contrib yaml

                       # currently broken in nix
                       # liquidhaskell
                       # lcs # doesn't build
                     ]
              ));
          });
        }
    );
}
