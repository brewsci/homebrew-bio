class Metabat < Formula
  # cite Kang_2015: "https://doi.org/10.7717/peerj.1165"
  desc "Statistical framework for reconstructing genomes from metagenomic data"
  homepage "https://bitbucket.org/berkeleylab/metabat/"
  url "https://bitbucket.org/berkeleylab/metabat/get/v2.18.tar.gz"
  sha256 "d547a75bef07bf9f6144d4ffe3fdd062ce7ecb89b23d083e74465ef2a99bb9ef"
  head "https://bitbucket.org/berkeleylab/metabat.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "brewsci/bio/boost@1.86"
  depends_on "htslib"
  depends_on "icu4c@77"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  def install
    # use c++14
    inreplace "CMakeLists.txt" do |s|
      s.gsub!("CMAKE_CXX_STANDARD 17", "CMAKE_CXX_STANDARD 14")
      s.gsub!("CMAKE_C_STANDARD 17", "CMAKE_C_STANDARD 14")
    end
    inreplace "src/CMakeLists.txt",
              "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}",
              "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS} -Wno-c++11-narrowing -Wno-non-pod-varargs"
    if OS.mac?
      inreplace "src/CMakeLists.txt", "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_EXE_LINKER_FLAGS}",
                "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_EXE_LINKER_FLAGS} -L#{Formula["libomp"].opt_lib} -lomp"
    end
    # Use lock_guard instead of scoped_lock for C++14 compatibility
    inreplace "src/contigOverlaps.cpp", "scoped_lock", "lock_guard"
    inreplace "src/jgi_summarize_bam_contig_depths.h" do |s|
      s.gsub!("_alloc.reset(new BaseCountType[requiredLen]);",
              "_alloc.reset(new BaseCountType[requiredLen], std::default_delete<BaseCountType[]>());")
      s.gsub!("shared_ptr<CountType[]>", "shared_ptr<CountType>")
      s.gsub!("shared_ptr<BaseCountType[]>", "shared_ptr<BaseCountType>")
    end
    inreplace "src/jgi_summarize_bam_contig_depths.cpp" do |s|
      s.gsub!("reset(new CountType[header->n_targets]);",
              "reset(new CountType[header->n_targets], std::default_delete<CountType[]>());")
      s.gsub!("#include <mutex>", "#include <mutex>\n#include <memory>")
    end
    # remove "VERSION" file to avoid an error: "error: expected unqualified-id"
    mv "VERSION", "version.txt"
    ENV["VERSION"] = version
    inreplace "cmake/Modules/GetGitVersion.cmake" do |s|
      s.gsub!("/VERSION", "/version.txt")
      s.gsub!("cat VERSION", "cat version.txt")
    end

    cmakeargs = %W[
      -DBoost_USE_STATIC_LIBS:BOOL=ON
      -DBoost_INCLUDE_DIR:PATH=#{Formula["brewsci/bio/boost@1.86"].opt_include}
      -DBoost_LIBRARY_DIR_RELEASE:PATH=#{Formula["brewsci/bio/boost@1.86"].opt_lib}
    ]
    system "cmake", "-S", ".", "-B", "build",
                    *std_cmake_args, *cmakeargs
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test", testpath
    cd "test" do
      system "#{bin}/jgi_summarize_bam_contig_depths",
             "--outputDepth", "depth.txt",
             "contigs-1000.fastq.bam"
      assert_match "NODE_1_length_5374_cov_8.558988", File.read("depth.txt")
      assert_match "0 bins (0 bases in total) formed.",
                   shell_output("#{bin}/metabat2 -i contigs.fa -l -a depth.txt -o bin 2>&1")
    end
  end
end
