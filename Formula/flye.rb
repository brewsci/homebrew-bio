class Flye < Formula
  # cite Kolmogorov_2018: "https://doi.org/10.1101/247148"
  desc "Fast and accurate de novo assembler for single molecule sequencing reads"
  homepage "https://github.com/fenderglass/Flye"
  url "https://github.com/fenderglass/Flye/archive/2.6.tar.gz"
  sha256 "5bdc44b84712794fa4264eed690d8c65c0d72f495c7bbf2cd15b634254809131"
  head "https://github.com/fenderglass/Flye.git", :branch => "flye"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "d6cb8e23b7b58d005697015cba3219d16a9a03109dfe6148762ecb75478b3f9c" => :sierra
    sha256 "1f82ac7b17a1d276c6f5c2dfaf668b22ae6e021c94c915fe39b5a4e31d7d9968" => :x86_64_linux
  end

  depends_on "python"

  def install
    system "python3", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    assert_match "usage", shell_output("#{bin}/flye --help")
  end
end
