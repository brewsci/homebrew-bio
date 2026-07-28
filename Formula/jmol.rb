class Jmol < Formula
  desc "Open-source Java viewer for chemical structures in 3D"
  homepage "https://jmol.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/jmol/Jmol/Version%2016.4/Jmol%2016.4.13/Jmol-16.4.13-binary.zip"
  sha256 "c22aa9fcea4227e618e12b7e2a31858a89066e00e97ab3ca665cef96a3e47196"
  license "LGPL-2.1-or-later"

  # SourceForge nests each release under a Version%20X.Y folder that cannot be
  # reconstructed from the file version, so bumps must be done manually.
  livecheck do
    skip "SourceForge nests a version folder not derivable from the file version"
  end

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, catalina:     "0cd34c8ceeb45a5bdfff32d1e1f7d4ff52f28e47d3a110059c0d79de989b2e16"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3eb4170227c820e1df107c72ce3b27d3a5c4b494025a5fb074ed8539bc28b362"
  end

  head do
    url "https://svn.code.sf.net/p/jmol/code/trunk/Jmol"
    depends_on "ant" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "ant"
      libexec.install Dir["build/*.jar"]
    else
      libexec.install Dir["*.jar"]
    end
    chmod 0755, "jmol.sh"
    bin.install "jmol.sh" => "jmol"
    env = {
      JMOL_HOME: libexec,
      JAVA_HOME: formula_opt_prefix("openjdk"),
      PATH:      "#{formula_opt_bin("openjdk")}:$PATH",
    }
    bin.env_script_all_files libexec/"bin", env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jmol -n") if OS.mac?

    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      # unfortunately, the application can not be run headless
      assert_match "java.awt.HeadlessException",
shell_output("#{bin}/jmol -n 2>&1", 1)
    end
  end
end
