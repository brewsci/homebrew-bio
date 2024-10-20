class Libsbml < Formula
  desc "Library for handling SBML (Systems Biology Markup Language)"
  homepage "https://sbml.org/software/libsbml"
  url "https://github.com/sbmlteam/libsbml/archive/refs/tags/v5.20.4.tar.gz"
  sha256 "02c225d3513e1f5d6e3c0168456f568e67f006eddaab82f09b4bdf0d53d2050e"
  license "LGPL-2.1-only"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "be5e90bfa775b0063438a2e4464905cfe61af14d21da9fc17b972d55851b3055"
    sha256 cellar: :any,                 arm64_sonoma:  "319dad5a76e564530aeaa4cf90dc0640fb5d966f4cd364f1a3b6e467bed1395f"
    sha256 cellar: :any,                 ventura:       "fff6ae359b43ac163c8eb888b19546443ceb6175ba5236f63950ef11f20c8403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9392a9ed0c1207b000ad8b4cda73a8ba671424ff111b94fbcf3b4b4cadc30890"
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
