class Beast2 < Formula
  # cite Bouckaert_2014: "https://doi.org/10.1371/journal.pcbi.1003537"
  desc "Bayesian evolutionary analysis by sampling trees"
  homepage "https://www.beast2.org/"
  url "https://github.com/CompEvol/beast2/archive/v2.6.1.tar.gz"
  sha256 "4d5314c7226b0a1e506be8b94239257e8de6746888519bf2159063b21dd171a8"

  bottle do
    cellar :any_skip_relocation
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "d172b12ab67807d7d3f1e61769782b24c47bf912a8ba27c2333311a7e6166f32" => :sierra
    sha256 "36ebbabeb1f1e7b7f33ee8f6aebb2f438237539ea38e9607390ecf3d49b0391a" => :x86_64_linux
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
