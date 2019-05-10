class Metabat < Formula
  # cite Kang_2015: "https://doi.org/10.7717/peerj.1165"
  desc "Statistical framework for reconstructing genomes from metagenomic data"
  homepage "https://bitbucket.org/berkeleylab/metabat/"
  url "https://bitbucket.org/berkeleylab/metabat/get/v2.13.tar.gz"
  sha256 "aa75a2b62ec9588add4c288993821bab5312a83b1259ff0d508c215133492d74"
  head "https://bitbucket.org/berkeleylab/metabat.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "a4f61a63b2ec1344807d0da324626b15b1a49a710e471238f05fe158cf20dceb" => :x86_64_linux
  end

  depends_on :linux unless build.head?

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build

  fails_with :clang # needs OpenMP

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
    def caveats; <<~EOS
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
      assert_match "0 bins (0 bases in total) formed.", shell_output("#{bin}/metabat2 -i contigs.fa -l -a depth.txt -o bin 2>&1")
    end
  end
end
