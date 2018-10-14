class Meraculous < Formula
  # cite Chapman_2011: "https://doi.org/10.1371/journal.pone.0023501"
  desc "Whole genome assembler for NGS reads geared for large genomes"
  homepage "https://jgi.doe.gov/data-and-tools/meraculous/"
  url "https://downloads.sourceforge.net/project/meraculous20/Meraculous-v2.2.6.tar.gz"
  sha256 "c9cf84ed6a7a15544ccff603c740b1b777cbf5b9ebc891a0a69f2c8a3b24e908"

  depends_on "cmake" => :build
  depends_on "cpanminus" => :build
  depends_on "boost"
  depends_on "gcc" if OS.mac? # for openmp
  depends_on "gnuplot"
  depends_on "perl"

  fails_with :clang # needs openmp

  def install
    # Fix Could not find the following static Boost libraries: boost_thread
    inreplace "src/c/CMakeLists.txt",
      "set(Boost_USE_MULTITHREADED OFF)",
      "set(Boost_USE_MULTITHREADED ON)"

    # Fix typo in source code
    inreplace "src/perl/_bubbleFinder2.pl",
      ".PATH_MERBLAST_112",
      ".PATH_MERBLAST_128"

    inreplace "src/perl/N50.pl",
      "die $usage",
      "exit 0"

    # Fix error: asm/param.h: No such file or directory
    # Fix error: 'HZ' undeclared (first use in this function)
    inreplace "src/c/linux.c",
      "#include <asm/param.h>",
      "#define HZ 100" if OS.mac?

    # Fix ld: library not found for -lrt
    inreplace "src/c/CMakeLists.txt",
      'set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -lrt" )',
      "" if OS.mac?

    # Fix env: perl\r: No such file or directory
    inreplace "src/perl/test_dependencies.pl", "\r", ""

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    system "cpanm", "--self-contained", "-l", libexec, "Log::Log4perl"
    bin.env_script_all_files libexec, "PERL5LIB" => ENV["PERL5LIB"]

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/run_meraculous.sh", "--version"
    system "#{prefix}/test_install.sh"
  end
end
