class Ascp < Formula
  desc "Aspera command-line download client"
  homepage "https://example.com/"
  if OS.mac?
    url "https://download.asperasoft.com/download/sw/cli/3.7.7/aspera-cli-3.7.7.608.927cce8-mac-10.7-64-release.sh"
    sha256 "c6f7af506a4de8858b8b40e63883e671926af7b43160d4fb6765790c56b299ba"
  else
    url "https://download.asperasoft.com/download/sw/cli/3.7.7/aspera-cli-3.7.7.608.927cce8-linux-64-release.sh"
    sha256 "83efd03b699bdb1cac6c62befb3812342d6122217f4944f732ae7a135d578966"
  end
  version "3.7.7"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "c78e4351309f0c0e543420d421d559f87f3b66c31a1212200263ea7c77752093" => :sierra
    sha256 "00416de41eae2e20018d28197714d868f12009c7012d9c914e74392cff80bbdc" => :x86_64_linux
  end

  unless OS.mac?
    depends_on "patchelf" => :build
  end

  def install
    # Deduce download name from URL
    installer = stable.url.sub %r{^.*/}, ""
    # installer = "ascp-#{version}.sh"
    # Patch in preferred install location (can't specify on cmdline)
    idir = OS.mac? ? '"$HOME/Applications"' : "~/.aspera"
    inreplace installer, "INSTALL_DIR=#{idir}", "INSTALL_DIR=#{prefix}"
    system "sh", installer
    # Move everything up a folder
    cdir = OS.mac? ? "Aspera CLI" : "cli"
    mv Dir["#{prefix}/#{cdir}/*"], prefix
    rmdir prefix/"cli"
    # Fix: Non-executables were installed to "/home/linuxbrew/.linuxbrew/opt/ascp/bin"
    rm "#{bin}/.aspera_cli_conf"
    rm "#{bin}/liburiparser.1.dylib" if OS.mac?
    # Patch binaries and remove libs on Linux
    unless OS.mac?
      rm_r prefix/"lib"
      Dir["#{bin}/*"].each do |exe|
        system "patchelf",
               "--set-interpreter", HOMEBREW_PREFIX/"lib/ld.so",
               "--set-rpath", HOMEBREW_PREFIX/"lib",
               exe
      end
    end
  end

  def caveats
    <<~EOS
      Aspera keys are in #{prefix}/etc
      Aspera certificates are in #{prefix}/certs
    EOS
  end

  test do
    assert_match "PROXY", shell_output("#{bin}/ascp -h 2>&1", 0)
  end
end
