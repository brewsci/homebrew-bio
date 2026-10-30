class Beast2 < Formula
  # cite Bouckaert_2014: "https://doi.org/10.1371/journal.pcbi.1003537"
  desc "Bayesian evolutionary analysis by sampling trees"
  homepage "https://www.beast2.org/"
  url "https://github.com/CompEvol/beast2/archive/refs/tags/v2.7.8.tar.gz"
  sha256 "a616e12e72b0fde29f2686ed8924d552ff53454c34be353591488b45733a56df"
  license "LGPL-2.1"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "91b1bb0fcd2ddc4fb60777946c9ce057e0a01125096a0557c20ce4b6ecd4ab3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0f9fea00d1f42297827baa50bf394be9c425da3343affe67ee46cc58d675edef"
  end

  depends_on "ant" => :build
  depends_on "openjdk"

  def install
    system "ant", "linux"

    cd "release/Linux/beast" do
      # Set `beast.user.package.dir` to `opt_pkgshare`. This will:
      # 1) Prevent BEAST from installing packages outside the Homebrew Cellar
      # 2) Preserve addon packages between BEAST version updates
      inreplace Dir["bin/*"], "-cp", "-Dbeast.user.package.dir=#{opt_pkgshare} -cp"
      pkgshare.install "examples"
      libexec.install Dir["*"]

      # Suffix binaries to prevent conflicts with BEAST 1.x
      (libexec/"bin").each_child { |f| bin.install_symlink f => bin/"#{f.basename}-2" }
    end
    doc.install Dir["doc/*"]
  end

  def caveats
    <<~EOS
      This install coexists with BEAST 1.x as all scripts are suffixed with '-2':
          beast-2 -help

      To use the unprefixed versions, add #{libexec}/bin to your PATH.
    EOS
  end

  test do
    cp pkgshare/"examples/testCalibration.xml", testpath
    # Run fewer generations to speed up tests
    inreplace "testCalibration.xml", "10000000", "1000000"

    system "#{bin}/beast-2", "-java", "-seed", "1000", "testCalibration.xml"
    system "#{bin}/treeannotator-2", "test.1000.trees", "out.tre"
    system "#{bin}/loganalyser-2", "test.1000.log"
  end
end
