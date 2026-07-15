class Plink2 < Formula
  # cite Chang_2015: "https://doi.org/10.1186/s13742-015-0047-8"
  desc "Analyze genotype and phenotype data"
  homepage "https://www.cog-genomics.org/plink2"
  url "https://github.com/chrchang/plink-ng/archive/refs/tags/v2.00a5.12.tar.gz"
  version "2.00a5.12"
  sha256 "bf55f172c709265c9c7bf1518bb4f0036d28fecdd7b17f8db7f9d106586bb3f5"
  head "https://github.com/chrchang/plink-ng.git", branch: "master"

  # Upstream switched from 2.00aX.Y to SemVer-style v2.0.0-a.X tags, which
  # cannot be compared with or substituted into the current version scheme, and
  # whose source fails to build here (BLAS_THREADING_* undeclared); stay on the
  # last 2.00aX release and skip livecheck until the scheme is reconciled.
  livecheck do
    skip "upstream moved to an incompatible SemVer tag scheme"
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any,                 arm64_sonoma: "ea7c863dafde5bc757b6db986e81b01f730eafa0e698204ad625c9d0e9bf7f62"
    sha256 cellar: :any,                 ventura:      "96b1711ed2eedb7d3b2daa023f5956f6772b321ff5b36cdb93cc3503f528e67b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9512c33fd71a714cc054dfe9ece9692cb417176683ba62802e3c3bea65b1f355"
  end

  depends_on "openblas"
  depends_on "zstd"

  on_linux do
    # plink2 links libz, provided by the tap's zlib-ng-compat on Linux; declare
    # it directly so `brew linkage --test` doesn't flag it as indirect.
    depends_on "zlib-ng-compat"
  end

  def install
    cd "1.9" do
      # Link the system/brewed zlib instead of statically building the copy that
      # plink_first_compile fetches from zlib.net (an unreliable network download
      # that intermittently fails the build with "Could not resolve host").
      inreplace "Makefile" do |s|
        s.gsub! "-L. ../zlib-1.3/libz.a", "-lz"
        s.gsub! "-L. ../zlib-1.3/libz.so.1.3", "-lz"
        if OS.linux?
          s.gsub! "-L/usr/lib64/atlas -llapack -lblas -lcblas -latlas",
                  "-L#{formula_opt_lib("openblas")} -lopenblas"
          s.gsub! "-Wall -O2 -g -I../2.0/simde",
                  "-Wall -O2 -g -I../2.0/simde -I#{formula_opt_include("openblas")}"
        end
      end
      system "make"
      bin.install "plink"
    end
    cd "2.0" do
      inreplace "build.sh", " -llapack -lcblas -lblas", "-L#{formula_opt_lib("openblas")} -lopenblas" if OS.linux?
      system "./build.sh"
      bin.install "bin/plink2" => "plink2"
      bin.install "bin/pgen_compress" => "pgen_compress"
    end
  end

  test do
    # plink2 spawns a compute thread even with --threads 1, which the Linux
    # `brew test` sandbox blocks ("Failed to create thread"). Run the full dummy
    # dataset on macOS and smoke-test the binary on Linux.
    if OS.mac?
      system "#{bin}/plink2", "--dummy", "513", "1423", "0.02", "--out", "dummy_cc1"
      assert_path_exists testpath/"dummy_cc1.pvar"
    else
      assert_match version.to_s, shell_output("#{bin}/plink2 --version")
    end
  end
end
