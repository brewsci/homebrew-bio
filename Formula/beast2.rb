class Beast2 < Formula
  # cite Bouckaert_2014: "https://doi.org/10.1371/journal.pcbi.1003537"
  desc "Bayesian evolutionary analysis by sampling trees"
  homepage "https://www.beast2.org/"
  url "https://github.com/CompEvol/beast2/archive/v2.5.0.tar.gz"
  sha256 "678967e698a24ffa40b11e74b07016c064be75fd114f4ea42b21cc58d07d7557"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "6fe1fd9679d3526f70bc610ccc039a589f9a24fdfe84ebfd5b5cbefe953e7012" => :sierra
    sha256 "333eea1f859d21c26249c6959fc9f2dec4c12da12d1f73f18c515da11c91640f" => :x86_64_linux
  end

  depends_on "ant" => :build
  depends_on :java

  def install
    # Homebrew renames the unpacked source folder, but build.xml
    # assumes that it won't be renamed.
    inreplace "build.xml", "../beast2/", ""
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

  def caveats; <<~EOS
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
