class HhSuite < Formula
  # cite Steinegger_2019: "https://doi.org/10.1186/s12859-019-3019-7"
  desc "Remote protein homology detection suite"
  homepage "https://github.com/soedinglab/hh-suite"
  url "https://github.com/soedinglab/hh-suite/archive/v3.2.0.tar.gz"
  sha256 "6b870dcfbc1ffb9dd664a45415fcd13cf5970f49d1c7b824160c260fa138e6d6"

  depends_on "cmake" => :build
  depends_on "gcc@8" => :build
  depends_on "perl"
  depends_on "python"

  def install
    Dir.mkdir("build")
    Dir.chdir("build")
    system "cmake", "-DCMAKE_INSTALL_PREFIX=#{prefix}", ".."
    system "make", "CC=gcc-8", "CXX=g++-8"
    system "make", "install"
  end

  test do
    system "hhblits -h > /dev/null"
    system "hhsearch -h > /dev/null"
    system "hhalign -h > /dev/null"
  end
end
