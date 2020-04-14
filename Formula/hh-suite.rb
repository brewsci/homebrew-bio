class HhSuite < Formula
  # cite Steinegger_2019: "https://doi.org/10.1186/s12859-019-3019-7"
  desc "Remote protein homology detection suite"
  homepage "https://github.com/soedinglab/hh-suite"
  url "https://github.com/soedinglab/hh-suite/archive/v3.2.0.tar.gz"
  sha256 "6b870dcfbc1ffb9dd664a45415fcd13cf5970f49d1c7b824160c260fa138e6d6"
  revision 1

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "69d36ff4487f42a65094c51cbeaa85f672a8f9870b8c2005733a94321982511e" => :catalina
    sha256 "2a58ad1ae56b5b35809d8bbf3e95bb4f9a7b87e9190c1ab81328943830012622" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "python"

  uses_from_macos "perl"

  fails_with :clang # needs openmp

  on_macos do
    depends_on "gcc" # needs openmp
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "Usage", shell_output("#{bin}/hhalign -h")
    assert_match "Usage", shell_output("#{bin}/hhblits -h")
    assert_match "Usage", shell_output("#{bin}/hhsearch -h")
  end
end
