class Jmol < Formula
  desc "Open-source Java viewer for chemical structures in 3D"
  homepage "https://jmol.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/jmol/Jmol/Version%2014.31/Jmol%2014.31.28/Jmol-14.31.28-binary.zip"
  sha256 "e1dfac0d652700a1416599007febbdc601680aaf89b5825aae033e94bdc79686"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 cellar: :any_skip_relocation, catalina: "dd9142c72f77f5e059237016431c94501b06c1e9c3a0d497f2f5ff5aabcc38bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ff7e125e752c0edca5d7176d41c8070bce367beb09651de0eec81f820f75f5b0"
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
      JAVA_HOME: Formula["openjdk"].opt_prefix,
      PATH:      "#{Formula["openjdk"].opt_bin}:$PATH",
    }
    bin.env_script_all_files libexec/"bin", env
  end

  test do
    on_macos do
      assert_match version.to_s, shell_output("#{bin}/jmol -n")
    end

    on_linux do
      # unfortunately, the application can not be run headless
      assert_match "java.awt.HeadlessException", shell_output("#{bin}/jmol -n 2>&1", 1) if ENV["CI"]
    end
  end
end
