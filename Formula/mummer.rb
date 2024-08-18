class Mummer < Formula
  # cite Marçais_2018: "https://doi.org/10.1371/journal.pcbi.1005944"
  # cite Kurtz_2004: "https://doi.org/10.1186/gb-2004-5-2-r12"
  desc "Alignment of large-scale DNA and protein sequences"
  homepage "https://mummer4.github.io/"
  url "https://github.com/mummer4/mummer/archive/refs/tags/v4.0.0rc1.tar.gz"
  sha256 "bf90dd5bb40f425d8a0f786857b570c45c4ca62807a370f390f54b4f240b8a54"
  license "Artistic-2.0"
  head "https://github.com/mummer4/mummer.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, sierra:       "2642a41271e0a4d0522c3d1890d1dfc6ced4ad03aa90ba31c37210f0a96a2e41"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "22df96cb1a3e421e5af2e432e3cfc10834ee13fa1e2916aae6a820dbcddcf8c5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "swig" => :build
  depends_on "perl" # for EXTERN.h
  depends_on "python@3.12"
  uses_from_macos "ruby"

  on_macos do
    depends_on "libomp"
  end

  resource "yaggo" do
    url "https://github.com/gmarcais/yaggo/releases/download/v1.5.9/yaggo"
    sha256 "d1d140da6ee73cf74c557e275d7052d1c1e3d0ae81e94b14621d5bea59cc5ac7"
  end

  patch :DATA

  def install
    buildpath.install resource("yaggo")
    chmod 0755, "yaggo"
    system "autoreconf", "-fvi"

    ruby = DevelopmentTools.locate("ruby")

    args = *std_configure_args + %W[
      YAGGO=#{buildpath}/yaggo
      RUBY=#{ruby}
      --enable-all-binding
      --enable-swig
    ]
    if OS.mac?
      args << "ax_cv_cxx_openmp=-Xpreprocessor"
      args << "LDFLAGS=-lomp"
    end
    system "./configure", *args
    system "make"
    system "make", "install"
    mv bin/"annotate", bin/"annotate-mummer"
    doc.install Dir["docs/*"]
    prefix.install "scripts"
  end

  def caveats
    <<~EOS
      `annotate` command is installed as `annotate-mummer`
      to avoid conflicts with other packages such as `gd`.

      To use the visualization tools included with MUMmer,
      run `brew install fig2dev gnuplot xfig`.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nucmer --version 2>&1")
  end
end
__END__
diff --git a/swig/nucmer.i b/swig/nucmer.i
index 0eb2776..e06bd1f 100644
--- a/swig/nucmer.i
+++ b/swig/nucmer.i
@@ -2,7 +2,19 @@
 #include <sstream>
 %}

-%template(LongVector) ::std::vector<long>;
+%include <std_vector.i>
+
+namespace std {
+    template<typename T> class vector;
+}
+
+namespace mummer {
+namespace postnuc {
+    struct Alignment;
+}
+}
+
+%template(LongVector) std::vector<long>;

 namespace mummer {

@@ -14,7 +26,7 @@ struct Alignment   {
   //-- An alignment object between two sequences A and B
   signed char         dirB;     // the query sequence direction
   long int            sA, sB, eA, eB; // the start in A, B and the end in A, B
-  ::std::vector<long> delta;    // the delta values, with NO zero at the end
+  std::vector<long> delta;    // the delta values, with NO zero at the end
   long int            deltaApos; // sum of abs(deltas) - #of negative deltas
   long int            Errors, SimErrors, NonAlphas; // errors, similarity errors, nonalphas
   double identity() const;
@@ -29,7 +41,6 @@ struct Alignment   {
     }
   }
 };
-%template(AlignmentVector) ::std::vector<mummer::postnuc::Alignment>;
 } // namespace postnuc

 namespace nucmer {
@@ -77,9 +88,10 @@ struct Options {
 };
 %apply (const char* STRING, size_t LENGTH) { (const char* reference, size_t reference_len) };
 %apply (const char* STRING, size_t LENGTH) { (const char* query, size_t query_len) };
-::std::vector<mummer::postnuc::Alignment> align_sequences(const char* reference, size_t reference_len,
+std::vector<mummer::postnuc::Alignment> align_sequences(const char* reference, size_t reference_len,
                                                           const char* query, size_t query_len,
                                                           mummer::nucmer::Options opts = mummer::nucmer::Options());
 } // namespace nucmer
 } // namespace mummer

+%template(AlignmentVector) std::vector<mummer::postnuc::Alignment>;
