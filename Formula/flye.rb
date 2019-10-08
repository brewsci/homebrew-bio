class Flye < Formula
  # cite Kolmogorov_2018: "https://doi.org/10.1101/247148"
  desc "Fast and accurate de novo assembler for single molecule sequencing reads"
  homepage "https://github.com/fenderglass/Flye"
  url "https://github.com/fenderglass/Flye/archive/2.6.tar.gz"
  sha256 "5bdc44b84712794fa4264eed690d8c65c0d72f495c7bbf2cd15b634254809131"
  head "https://github.com/fenderglass/Flye.git", :branch => "flye"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "63e01cab4cb5870d60fca897ae5c3cd8b52d3bd249a3aa129454910c4fbd2d1f" => :sierra
    sha256 "d5df5ebfe67e7de0df758c8eaa9a2cc9fe090955a92dca5502db50237688736d" => :x86_64_linux
  end

  depends_on "python"

  def install
    system "python3", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    assert_match "usage", shell_output("#{bin}/flye --help")
  end
end
