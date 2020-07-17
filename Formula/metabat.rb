class Metabat < Formula
  # cite Kang_2015: "https://doi.org/10.7717/peerj.1165"
  desc "Statistical framework for reconstructing genomes from metagenomic data"
  homepage "https://bitbucket.org/berkeleylab/metabat/"
  url "https://bitbucket.org/berkeleylab/metabat/get/v2.15.tar.gz"
  sha256 "550487b66ec9b3bc53edf513d00c9deda594a584f53802165f037bde29b4d34e"
  head "https://bitbucket.org/berkeleylab/metabat.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "4fcd6b616061cd662956ca9ccb57dcfc5e61e10024d9313ee0a3e9ae89adcea5" => :x86_64_linux
  end

  depends_on :linux unless build.head?

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build

  fails_with :clang # needs openmp

  if OS.mac?
    resource "boost" do
      url "https://downloads.sourceforge.net/project/boost/boost/1.69.0/boost_1_69_0.tar.gz"
      sha256 "9a2c2819310839ea373f42d69e733c339b4e9a19deab6bfec448281554aa4dbb"
    end
  else
    depends_on "boost"
  end

  def install
    if OS.mac?
      boost_libs = %w[program_options filesystem system graph serialization iostreams]
      boost_dir = buildpath/"boost"

      # weird bug where /usr/local boost is selected despite
      # -DBoost_NO_SYSTEM_PATHS=TRUE, so the libraries are specified manually
      inreplace buildpath/"src/CMakeLists.txt", /^find_package\(Boost.*$/, <<~EOS
        set(Boost_INCLUDE_DIRS ${BOOST_ROOT})
        set(Boost_LIBRARIES #{boost_libs.map do |comp|
          "#{boost_dir}/stage/lib/libboost_#{comp}.a"
        end.join(" ")})
      EOS

      resource("boost").stage do
        mkdir boost_dir
        cp_r ".", boost_dir
      end

      cd boost_dir do
        system "./bootstrap.sh", "--with-toolset=gcc", "--with-libraries=#{boost_libs.join(",")}"
        system "./b2", "link=static", "visibility=global"
      end

      system "cmake", ".", "-DBOOST_ROOT=#{boost_dir}", *std_cmake_args
    else
      system "cmake", ".", *std_cmake_args
    end

    system "make", "install"

    pkgshare.install("test")
  end

  if OS.mac?
    def caveats
      <<~EOS
        Only HEAD currently works on macOS. Use the following to install:

            brew install --HEAD brewsci/bio/metabat

      EOS
    end
  end

  test do
    cp_r pkgshare/"test", testpath
    cd "test" do
      system "#{bin}/jgi_summarize_bam_contig_depths",
             "--outputDepth", "depth.txt",
             "contigs-1000.fastq.bam"
      assert_match "NODE_1_length_5374_cov_8.558988	5404	14.2158	14.2158	16.817", File.read("depth.txt")
      assert_match "0 bins (0 bases in total) formed.",
                   shell_output("#{bin}/metabat2 -i contigs.fa -l -a depth.txt -o bin 2>&1")
    end
  end
end
