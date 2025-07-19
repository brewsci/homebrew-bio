class Libcifpp < Formula
  desc "Library containing code to manipulate mmCIF and PDB files"
  homepage "https://pdb-redo.github.io/libcifpp/"
  url "https://github.com/PDB-REDO/libcifpp/archive/refs/tags/v8.0.1.tar.gz"
  sha256 "53f0ff205711428dcabf9451b23804091539303cea9d2f54554199144ca0fc4e"
  license "BSD-2-Clause"
  head "https://github.com/PDB-REDO/libcifpp.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256                               arm64_sequoia: "5f6872a872572ae14457b257942bd7409241675f9cfdcae45442cea3784da307"
    sha256                               arm64_sonoma:  "1798ef5398ddf5715e35a44b2cac1e0c5398bed01be753e382316d20bd12d673"
    sha256                               ventura:       "86bd0f5263d920fe307917a04f46156e462f2441692b0be25c8ed6af8b0f71cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fabcb64700451cfc99da7fc6884176f7ff0a1535227856516387cb15f63b4a7d"
  end

  depends_on "cmake" => :build
  depends_on "eigen" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "boost"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
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
