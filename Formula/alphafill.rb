class Alphafill < Formula
  # cite Hekkelman_2023: "https://doi.org/10.1038/s41592-022-01685-y"
  desc "Transplant missing compounds to the AlphaFold models"
  homepage "https://github.com/PDB-REDO/alphafill"
  url "https://github.com/PDB-REDO/alphafill/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "db90ee97ff6e691945f7672c368f4ef43fc106976a14b07ffa153de07fb70019"
  license "BSD-2-Clause"
  head "https://github.com/PDB-REDO/alphafill.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 arm64_sequoia: "14a4f1588d63784f115108d8790a582839cbf112be29bf6e9dba479bc34943e8"
    sha256 arm64_sonoma:  "bd151620e2c2a1d807d8e17f90862e3b30b228d1d6c9ba40c1d22c28ed71c844"
    sha256 ventura:       "33dced5b45d30fa169dfb3ec8756e722ed307a0eb6911ac99c6fd0307f26e758"
    sha256 x86_64_linux:  "1173db7569de93c3ce22bb8ef33ebe561bcf7f38ecb75523669c6afe10bf768b"
  end

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "fast_float"
  depends_on "howard-hinnant-date"
  depends_on "pcre2"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on xcode: :build if DevelopmentTools.clang_build_version <= 1500
  end

  on_linux do
    depends_on "gcc" => :build # for C++20 support
    depends_on "fmt"
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "12"
    cause "requires GCC 13+"
  end

  resource "cifpp" do
    url "https://github.com/PDB-REDO/libcifpp/archive/refs/tags/v9.0.4.tar.gz"
    sha256 "b7c3ac628c2ea78febf98f54fdd7a595773bddb07cbedcd55b9866b11a013aba"
  end

  resource "mcfp" do
    url "https://github.com/mhekkel/libmcfp/archive/refs/tags/v1.4.2.tar.gz"
    sha256 "dcdf3e81601081b2a9e2f2e1bb1ee2a8545190358d5d9bec9158ad70f5ca355e"
  end

  resource "zeep" do
    url "https://github.com/mhekkel/libzeep/archive/refs/tags/v7.2.0.tar.gz"
    sha256 "da02dd20b1f82d0628e9a973052f119cd118cf40b55d76e054d79d46bee0e1e8"
  end

  resource "mxml" do
    url "https://forge.hekkelman.net/maarten/mxml/archive/v2.0.2.tar.gz"
    sha256 "41a6cf9ddf2e474f166be774994599e7dd853450dab5ce41a897ad60a5fb1f3e"
  end

  def install
    ENV.append "CXXFLAGS", "-std=c++20"
    resource("cifpp").stage do
      # cifpp should be installed in 'prefix' directory since the path of dic files are always required.
      system "cmake", "-S", ".", "-B", "build",
             "-DCMAKE_CXX_STANDARD=20",
             *std_cmake_args(install_prefix: prefix/"cifpp")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    resource("mcfp").stage do
      # mcfp should be installed in 'prefix' directory since the path of dic files are always required.
      system "cmake", "-S", ".", "-B", "build",
             "-DCMAKE_CXX_STANDARD=20",
             *std_cmake_args(install_prefix: prefix/"mcfp")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    resource("mxml").stage do
      inreplace "CMakeLists.txt",
          "target_include_directories(mxml PRIVATE $<TARGET_PROPERTY:fast_float,INTERFACE_INCLUDE_DIRECTORIES>)",
          <<~EOS
            if(TARGET fast_float)
              target_include_directories(mxml PRIVATE $<TARGET_PROPERTY:fast_float,INTERFACE_INCLUDE_DIRECTORIES>)
            endif()
          EOS
      system "cmake", "-S", ".", "-B", "build",
                      "-DCMAKE_CXX_STANDARD=20",
                      *std_cmake_args(install_prefix: prefix/"mxml")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    resource("zeep").stage do
      system "cmake", "-S", ".", "-B", "build",
             "-DCMAKE_CXX_STANDARD=20",
             "-Dmxml_DIR=#{prefix/"mxml/lib/cmake/mxml"}",
             "-DCMAKE_BUILD_TYPE=Release",
             *std_cmake_args(install_prefix: prefix/"zeep")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    # WEB_APPLICATION and BUILD_DOCUMENTATION were OFF because they failed to build
    # if macOS sonoma, use Apple Clang
    args = %w[
      -DBUILD_DOCUMENTATION=OFF
      -DBUILD_WEB_APPLICATION=OFF
    ]
    if OS.mac? && DevelopmentTools.clang_build_version <= 1500
      args << "-DCMAKE_CXX_COMPILER=clang++"
      args << "-DCMAKE_C_COMPILER=clang"
    end
    system "cmake", "-S", ".", "-B", "build",
                    "-Dmcfp_DIR=#{prefix/"mcfp/lib/cmake/mcfp"}",
                    "-Dcifpp_DIR=#{prefix/"cifpp/lib/cmake/cifpp"}",
                    "-Dzeep_DIR=#{prefix/"zeep/lib/cmake/zeep"}",
                    "-DALPHAFILL_DATA_DIR=#{pkgshare}",
                    *args,
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "test"
  end

  test do
    (testpath/"alphafill.conf").write <<~EOS
      pdb-dir=#{prefix}/test/mini-pdb-redo/
      pdb-fasta=#{testpath}/pdb-redo.fa
      ligands=#{share}/alphafill/af-ligands.cif
    EOS
    ENV["CIFPP_DATA_DIR"] = "#{prefix}/cifpp"
    system "#{bin}/alphafill", "create-index"
    assert_match ">pdb-entity|2CBS|1|R13\nPNFSGNW", File.read("#{testpath}/pdb-redo.fa")
    system "#{bin}/alphafill", "process", "--config", "#{testpath}/alphafill.conf",
           "#{prefix}/test/afdb-v4/P2/AF-P29373-F1-model_v4.cif.gz",
           "#{testpath}/out.cif.gz"
    assert_path_exists testpath/"out.cif.gz"
    assert_match "RETINOIC ACID", shell_output("gunzip -c #{testpath}/out.cif.gz")
  end
end
