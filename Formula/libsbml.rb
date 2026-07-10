class Libsbml < Formula
  desc "Library for handling SBML (Systems Biology Markup Language)"
  homepage "https://sbml.org/software/libsbml"
  url "https://github.com/sbmlteam/libsbml/archive/refs/tags/v5.21.1.tar.gz"
  sha256 "c595f9d6f04035863f9003986552a651b95df85c219b998b0c1c0ba14ff042fd"
  license "LGPL-2.1-only"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any, arm64_tahoe:   "b011fa53329da04075af32f93bcb1bb116bfc36e7f361f1655aa7b7e539f1dfb"
    sha256 cellar: :any, arm64_sequoia: "b130e5794cbbb6fa553c4faaff55baffbef35e8f9811f548141108e2c2388fba"
    sha256 cellar: :any, arm64_sonoma:  "e139c05d43c0c0c5b2c667967091d5edcaa75804d71b641621391f0a56f27c93"
    sha256 cellar: :any, x86_64_linux:  "650f918f35602e3227b4c7d25ce9838a127e7e1b1eb57a3408edfac947716a32"
  end

  depends_on "check" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"

  def install
    # avoid an error "invalid conversion from ‘const xmlError*’"
    ENV.append_to_cflags "-fpermissive" if OS.linux?
    args = %w[
      -DWITH_SWIG=OFF
      -DLIBSBML_SHARED_VERSION=OFF
      -DWITH_ZLIB=OFF
      -DWITH_BZIP2=ON
      -DENABLE_COMP=ON
      -DENABLE_FBC=ON
      -DENABLE_GROUPS=ON
      -DENABLE_L3V2EXTENDEDMATH=ON
      -DENABLE_LAYOUT=ON
      -DENABLE_MULTI=ON
      -DENABLE_QUAL=ON
      -DENABLE_RENDER=ON
    ]
    args << "-DLIBSBML_DEPENDENCY_DIR=#{HOMEBREW_PREFIX}"
    # Pass an absolute CMAKE_INSTALL_LIBDIR: this version's include(GNUInstallDirs)
    # re-types the variable as PATH, so a relative "lib" gets absolutized against
    # the source dir and the libraries install outside the keg (empty lib/).
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_libdir: lib)
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
