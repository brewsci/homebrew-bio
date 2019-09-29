class Ntedit < Formula
  # cite Warren_2019: "https://doi.org/10.1093/bioinformatics/btz400"
  desc "Scalable genome assembly polishing"
  homepage "https://github.com/bcgsc/ntEdit"
  url "https://github.com/bcgsc/ntEdit/archive/v1.2.3.tar.gz"
  sha256 "380d69a5ccfd0a5ea018982dd2a52b5dae524f34c7115aa326bb951f5dd7fb12"
  head "https://github.com/bcgsc/ntEdit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "468426b66a78d26c25a7c490c59d6e8f4897aef399f226f6db6d07c9ef3fca67" => :sierra
    sha256 "f50bc41a308c00614b4f29b9152ffb2b11937ef7950a64e3a393f36090654520" => :x86_64_linux
  end

  if OS.mac?
    depends_on "gcc" # for openmp
  else
    depends_on "zlib"
  end

  fails_with :clang # needs openmp

  def install
    system "make"
    bin.install "ntedit"
  end

  test do
    assert_match "Options", shell_output("#{bin}/ntedit --help 2>&1")
  end
end
