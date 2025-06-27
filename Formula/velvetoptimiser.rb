class Velvetoptimiser < Formula
  desc "Automatically optimise Velvet genome assemblies"
  homepage "https://github.com/tseemann/VelvetOptimiser"
  url "https://github.com/tseemann/VelvetOptimiser/archive/2.2.6.tar.gz"
  sha256 "b407db61b58ed983760b80a3a40c8f8a355851ecfab3e61a551bed29bf5b40b3"
  license "GPL-2.0"
  revision 1
  head "https://github.com/tseemann/VelvetOptimiser.git"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "637e1bbe1a8ee31055e64f14ee8912e3491640cbbb3e7e987fbc7ddf045aeb9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "eedf786ed0027c082a80482907f34f0ec39aa0c4608bf2a7235a7b3b60a9f396"
  end

  depends_on "bioperl"
  depends_on "brewsci/bio/velvet"

  uses_from_macos "perl"

  def install
    exe = "VelvetOptimiser.pl"
    bioperl = Formula["bioperl"].libexec/"lib/perl5"
    inreplace exe, "use threads;", "use lib '#{bioperl}';\nuse threads;"
    inreplace exe, ", '--preserve-root'", "" if OS.mac? # GNU-specific option
    prefix.install Dir["*"]
    bin.install_symlink prefix/exe => exe
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/VelvetOptimiser.pl --version")
  end
end
