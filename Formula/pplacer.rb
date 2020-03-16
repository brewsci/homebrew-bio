class Pplacer < Formula
  # cite Matsen_2010: "https://doi.org/10.1186/1471-2105-11-538"
  desc "Place query sequences on a fixed reference phylogenetic tree"
  homepage "https://matsen.fhcrc.org/pplacer/"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "67bc8639e0f54daa1c141b906814578cd26f9510f9803297c337b4a0c241f577" => :sierra
    sha256 "a3defbdaf841d3fb1297cb1175a29b7ecee7f964cd6e25cf95a1de7a4946a105" => :x86_64_linux
  end

  # We use binaries to avoid compiling OCaml code
  if OS.mac?
    url "https://github.com/matsen/pplacer/releases/download/v1.1.alpha17/pplacer-Darwin-v1.1.alpha17.zip"
    sha256 "db1ac64e1bc9b4d24d17ee2e388c061c283ca9fbec075e022bdeaad1adc6d41c"
  else
    url "https://github.com/matsen/pplacer/releases/download/v1.1.alpha17/pplacer-Linux-v1.1.alpha17.zip"
    sha256 "3dc8e20fa8642d01daadde5bf9e36df2c180abec8f85c0b2f296f7852b63537c"
  end

  depends_on "gsl" if OS.mac?

  def install
    binaries = ["pplacer", "guppy", "rppr"]
    if OS.mac?
      binaries.each do |bin|
        MachO::Tools.change_install_name bin, "/usr/local/lib/libgsl.0.dylib", "#{Formula["gsl"].lib}/libgsl.dylib"
        MachO::Tools.change_install_name bin,
          "/usr/local/lib/libgslcblas.0.dylib",
          "#{Formula["gsl"].lib}/libgslcblas.0.dylib"
        MachO::Tools.change_install_name bin, "/usr/local/lib/gcc/5/libgcc_s.1.dylib", "/usr/lib/libgcc_s.1.dylib"
      end
    end
    libexec.install "scripts"
    bin.install binaries
  end

  test do
    assert_match "pplacer [options]", shell_output("#{bin}/pplacer -help")
  end
end
