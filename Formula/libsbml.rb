class Libsbml < Formula
  desc "Library for handling SBML (Systems Biology Markup Language)"
  homepage "https://sbml.org/software/libsbml"
  url "https://github.com/sbmlteam/libsbml/archive/refs/tags/v5.20.2.tar.gz"
  sha256 "a196cab964b0b41164d4118ef20523696510bbfd264a029df00091305a1af540"
  license "LGPL-2.1-only"

  depends_on "check" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build

  if OS.mac?
    uses_from_macos "bzip2"
    uses_from_macos "libxml2"
    uses_from_macos "zlib"
  else
    depends_on "bzip2"
    depends_on "libxml2"
    depends_on "zlib"
  end

  def install
    args = %w[
      -DENABLE_FBC=ON
      -DENABLE_GROUPS=ON
      -DWITH_LIBXML=TRUE
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <sbml/SBMLTypes.h>
      #include <sbml/packages/fbc/common/FbcExtensionTypes.h>
      #include <sbml/packages/groups/common/GroupsExtensionTypes.h>

      LIBSBML_CPP_NAMESPACE_USE

      int main(int argc,char** argv)
      {
        SBMLNamespaces sbmlns(3,2);

        sbmlns.addPkgNamespace("fbc",1);
        sbmlns.addPkgNamespace("groups",1);

        // create the document

        SBMLDocument *document = new SBMLDocument(&sbmlns);
        document->setPackageRequired("fbc", false);
        document->setPackageRequired("groups", false);

        // create the model
        Model* model = document->createModel();

        // basic test
        model->setId("Homebrew_SBMLtest");
        std::cout << model->getId() << std::endl;

        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "-L#{lib}", "-I#{include}", "test.cpp", "-o", "test", "-lsbml"
    assert_equal "Homebrew_SBMLtest", shell_output("./test").strip
  end
end
