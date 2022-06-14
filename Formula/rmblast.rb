class Rmblast < Formula
  desc "RepeatMasker compatible version of the standard NCBI BLAST suite"
  homepage "https://www.repeatmasker.org/RMBlast.html"
  version "2.11.0"
  if OS.mac?
    url "https://www.repeatmasker.org/rmblast-#{version}+-x64-macosx.tar.gz"
    sha256 "e89159dd4532caf49c34b7e78d67e0ef0cb95622f64fbf285c182a9343db5046"
  else
    url "https://www.repeatmasker.org/rmblast-#{version}+-x64-linux.tar.gz"
    sha256 "3e0a37fd6ec01a4c02acbf161e6d517725a5af783b610da5c7139066f0f1e6df"
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "bd7e6df63714fb2cc07ea1bc5dc3fcfb23364d8f86a66fd6bf8af333d8a18dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e4179700df3ad81604cb6031a9d82e971d3fa88ac0c9b6d8f949af3b8be3edb8"
  end

  unless OS.mac?
    depends_on "patchelf" => :build
    depends_on "bzip2"
    depends_on "zlib"
  end

  keg_only "rmblast conflicts with blast"

  def install
    prefix.install Dir["*"]
    unless OS.mac?
      system "patchelf", bin/"rmblastn",
        "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
        "--set-rpath", HOMEBREW_PREFIX
    end
  end

  test do
    assert_match "USAGE", shell_output("#{bin}/rmblastn -help")
  end
end
