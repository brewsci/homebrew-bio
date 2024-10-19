class Libcifpp < Formula
  desc "Library containing code to manipulate mmCIF and PDB files"
  homepage "https://pdb-redo.github.io/libcifpp/"
  url "https://github.com/PDB-REDO/libcifpp/archive/refs/tags/v7.0.7.tar.gz"
  sha256 "0e88805b4704d4a899aeee6df5aaace1d6b47d8ccb3a3f39b35bc5a3997c09ac"
  license "BSD-2-Clause"
  head "https://github.com/PDB-REDO/libcifpp.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 arm64_sequoia: "585b63ef61340a385ff448a8454ba4da3ef6d48f474f0a5ef77a30af86e1cf8a"
    sha256 arm64_sonoma:  "7fdec8dc7803235bb92e0bffb4e6f37e8ca2f47bffd39936057fb5d4c4928e2a"
    sha256 ventura:       "babc751dfed5dc44f38437c762c701bcfcb2ef206e977ef6826b1e3df375cd0a"
    sha256 x86_64_linux:  "04763e420660a3e582a1115da016d4fe4be75e3de8c1321f1b7900939b396205"
  end

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "boost"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "testdata" do
      url "https://github.com/PDB-REDO/dssp/raw/fa880e3d88f842703f680185fffc4de540284b25/test/1cbs.cif.gz"
      sha256 "c6a2e4716f843bd608c06cfa4b6a369a56a6021ae16e5f876237b8a73d0dcb5e"
    end
    (testpath/"test.cpp").write <<~EOS
      #include <filesystem>
      #include <iostream>

      #include <cif++.hpp>

      namespace fs = std::filesystem;

      int main(int argc, char *argv[])
      {
          if (argc != 2)
              exit(1);

          // Read file, can be PDB or mmCIF and can even be compressed with gzip.
          cif::file file = cif::pdb::read(argv[1]);

          if (file.empty())
          {
              std::cerr << "Empty file" << std::endl;
              exit(1);
          }

          // Take the first datablock in the file
          auto &db = file.front();

          // Use the atom_site category
          auto &atom_site = db["atom_site"];

          // Count the atoms with atom-id "OXT"
          auto n = atom_site.count(cif::key("label_atom_id") == "OXT");

          std::cout << "File contains " << atom_site.size() << " atoms of which "
                    << n << (n == 1 ? " is" : " are") << " OXT" << std::endl
                    << "residues with an OXT are:" << std::endl;

          // Loop over all atoms with atom-id "OXT" and print out some info.
          // That info is extracted using structured binding in C++
          for (const auto &[asym, comp, seqnr] :
                  atom_site.find<std::string, std::string, int>(
                      cif::key("label_atom_id") == "OXT",
                      "label_asym_id", "label_comp_id", "label_seq_id"))
          {
              std::cout << asym << ' ' << comp << ' ' << seqnr << std::endl;
          }

          return 0;
      }
    EOS
    resource("testdata").stage testpath
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++20",
                    "-I#{include}", "-L#{lib}", "-lcifpp", "-lz"
    assert_match "File contains 1213 atoms of which 1 is OXT", shell_output("./test 1cbs.cif")
  end
end
