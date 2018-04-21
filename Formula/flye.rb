class Flye < Formula
  # cite Kolmogorov_2018: "https://doi.org/10.1101/247148"
  desc "Fast and accurate de novo assembler for single molecule sequencing reads"
  homepage "https://github.com/fenderglass/Flye"
  url "https://github.com/fenderglass/Flye/archive/2.3.3.tar.gz"
  sha256 "51fd081265d5f427343cd387e7f7e313a8dddfb1db6abfd00344d86b43ce1c90"
  head "https://github.com/fenderglass/Flye.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "d0bd9bcabf374ee0c624be18c4b429ce5c1497475a3abad73f60c573ef67bf1e" => :sierra_or_later
    sha256 "3b29b9f8386ea89f99c3a4621061259b36c3c72f0976e94b987b19e47364af57" => :x86_64_linux
  end

  needs :cxx11

  depends_on "python@2"

  def install
    system "python2", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    assert_match "usage", shell_output("#{bin}/flye --help")
  end
end
