class Alphafill < Formula
  # cite Hekkelman_2023: "https://doi.org/10.1038/s41592-022-01685-y"
  desc "Transplant missing compounds to the AlphaFold models"
  homepage "https://github.com/PDB-REDO/alphafill"
  url "https://github.com/PDB-REDO/alphafill/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "30b554a936fcf052c562020ac6dd516386863dfc710ac91be3a11b83bb4c69d1"
  license "BSD-2-Clause"
  head "https://github.com/PDB-REDO/alphafill.git", branch: "trunk"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "brewsci/bio/libcifpp"
  depends_on "brewsci/bio/libmcfp"
  depends_on "brewsci/bio/libzeep"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    inreplace "CMakeLists.txt" do |s|
      s.gsub! "find_package(libmcfp 1.2.4 QUIET)", "find_package(libmcfp REQUIRED)"
      s.gsub! "find_package(libpqxx 7.8.0 QUIET)",
              "find_package(PkgConfig)\npkg_check_modules(libpqxx REQUIRED libpqxx>=7.8.0)"
      s.gsub! "libpqxx::pqxx", "${LIBPQXX_LIBRARIES}"
    end
    # WEB_APPLICATION and BUILD_DOCUMENTATION were OFF because they failed to build
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_DOCUMENTATION=OFF",
                    "-DBUILD_WEB_APPLICATION=OFF",
                    "-DALPHAFILL_DATA_DIR=#{pkgshare}",
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
    system "#{bin}/alphafill", "create-index"
    assert_match ">pdb-entity|2CBS|1|R13\nPNFSGNW", File.read("#{testpath}/pdb-redo.fa")
    system "#{bin}/alphafill", "process", "--config", "#{testpath}/alphafill.conf",
           "#{prefix}/test/afdb-v4/P2/AF-P29373-F1-model_v4.cif.gz",
           "#{testpath}/out.cif.gz"
    assert_predicate testpath/"out.cif.gz", :exist?
    assert_match "RETINOIC ACID", shell_output("gunzip -c #{testpath}/out.cif.gz")
  end
end
