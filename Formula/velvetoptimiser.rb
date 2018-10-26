class Velvetoptimiser < Formula
  desc "Automatically optimise Velvet genome assemblies"
  homepage "https://github.com/tseemann/VelvetOptimiser"
  url "https://github.com/tseemann/VelvetOptimiser/archive/2.2.6.tar.gz"
  sha256 "b407db61b58ed983760b80a3a40c8f8a355851ecfab3e61a551bed29bf5b40b3"
  head "https://github.com/tseemann/VelvetOptimiser.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "81bbe7d594044c2ef8ac652705c0ee1fc402369391381c696e0038adbbba1f73" => :sierra
    sha256 "cce69e42775482486576e639f7fc096ea5f7852fdf064f70d01de81461d15db6" => :x86_64_linux
  end

  depends_on "bioperl"
  depends_on "perl" unless OS.mac?
  depends_on "velvet"

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
