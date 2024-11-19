class Libcifpp < Formula
  desc "Library containing code to manipulate mmCIF and PDB files"
  homepage "https://pdb-redo.github.io/libcifpp/"
  url "https://github.com/PDB-REDO/libcifpp/archive/refs/tags/v7.0.8.tar.gz"
  sha256 "2297e6649a4f71caf9da5f1d97f59512e7324bb62083bb5b08eb00c1c0385cb3"
  license "BSD-2-Clause"
  head "https://github.com/PDB-REDO/libcifpp.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 arm64_sequoia: "ffc4bfcfdc4cdae58f851c33be3a81a65f89fb75a8ad5a0efcf9cc923611d5de"
    sha256 arm64_sonoma:  "357ac8a14210901240a5adf805573bcac435aff33c400a43ad171c4e7aab7b8b"
    sha256 ventura:       "46e84668520d3429e2e79c863a83b4f8200efb9fd473ef38c7d142912b49c761"
    sha256 x86_64_linux:  "97eb87ca7b2c2a7d10501a9571b31d19a3c80aac801c7084dca9472ac0dafb62"
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
