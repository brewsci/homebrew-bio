class Pymol < Formula
  desc "OpenGL based molecular visualization system"
  homepage "https://pymol.org"
  url "https://downloads.sourceforge.net/projects/pymol/files/pymol/2/pymol-v2.1.0.tar.bz2"
  sha256 "7ae8ebb899533d691a67c1ec731b00518dea456ab3e258aa052a65c24b63eae2"

  depends_on "glew"
  depends_on "pyqt"
  depends_on "python"

  def install
    ENV.append_to_cflags "-Qunused-arguments" if MacOS.version < :mavericks

    system "python", "-s", "setup.py", "install",
                     "--osx-frameworks",
                     "--bundled-pmw",
                     "--install-scripts=#{libexec}/bin",
                     "--install-lib=#{libexec}/lib/python2.7/site-packages"

    bin.install libexec/"bin/pymol"
  end

  test do
    system bin/"pymol", libexec/"lib/python2.7/site-packages/pymol/pymol_path/data/demo/pept.pdb"
  end
end
