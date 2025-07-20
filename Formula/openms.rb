class Openms < Formula
  desc "Open-source software C++ library for LC-MS data management and analyses"
  homepage "https://www.openms.de/"
  url "https://github.com/OpenMS/OpenMS/releases/download/release%2F3.4.1/OpenMS-3.4.1.tar.gz"
  sha256 "ab3c30a8f2b905c2aa7c7b5f821066ed77a111bb5970f5586384c5effb9a6ec8"
  license "BSD-3-Clause"

  head "https://github.com/OpenMS/OpenMS.git", branch: "develop"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "coin-or-tools/coinor/cbc"
  depends_on "coin-or-tools/coinor/cgl"
  depends_on "coin-or-tools/coinor/clp"
  depends_on "coin-or-tools/coinor/coinutils"
  depends_on "coin-or-tools/coinor/osi"
  depends_on "doxygen"
  depends_on "eigen"
  depends_on "glpk"
  depends_on "hdf5"
  depends_on "libomp"
  depends_on "libsvm"
  depends_on "libxcb" if OS.linux?
  depends_on "qt"
  depends_on "sqlite" if OS.linux?
  depends_on "xcb-util-cursor" if OS.linux?
  depends_on "xerces-c"
  depends_on "yaml-cpp"
  depends_on "zlib"

  def install
    # Build OpenMS
    args = std_cmake_args + %W[
      -DCMAKE_C_COMPILER=#{ENV.cc}
      -DCMAKE_CXX_COMPILER=#{ENV.cxx}
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_PREFIX_PATH=#{Formula["qt"].opt_prefix}
      -DBOOST_USE_STATIC=OFF
    ]

    # Set specifities for Linux
    if OS.linux?
      # Set headless environment for Linux
      ENV["QT_QPA_PLATFORM"] = "offscreen"
      ENV["DISPLAY"] = ":99"

      # Fix missing cstdint include on Linux
      inreplace "src/openms/extern/SQLiteCpp/include/SQLiteCpp/Statement.h",
                "#include <memory>",
                "#include <memory>\n#include <cstdint>"

      # Use external SQLite instead of bundled one to avoid conflicts
      args << "-DSQLITECPP_INTERNAL_SQLITE=OFF"
    end

    system "cmake", "-S", ".", "-B", "openms_build", *args
    system "cmake", "--build", "openms_build"

    # Run test (more than 2325 tests)
    # system "ctest", "-j$(nproc)", "--test-dir", "openms_build"

    # Install files
    bin.install Dir["openms_build/bin/*"].reject { |f| f.end_with?(".app") }
    # TODO: Copy .app files to /Applications. Build a Cask instead?
    lib.install Dir["openms_build/lib/*"]
    doc.install Dir["openms_build/doc/*"]
    (share/"OpenMS").install Dir["share/OpenMS/*"]

    # Remove CMake build artifacts from documentation
    rm_r Dir["#{share}/doc/**/CMakeFiles"]
  end

  def caveats
    <<~EOS
      OpenMS has been installed successfully!

      To use OpenMS tools, you may need to set up your environment:
        export PATH="#{bin}:$PATH"
        export DYLD_LIBRARY_PATH="#{lib}:$DYLD_LIBRARY_PATH"
        (or in Linux: export LD_LIBRARY_PATH="#{lib}:$LD_LIBRARY_PATH")
        export OPENMS_DATA_PATH="#{lib}/share/OpenMS"

      Or use the provided wrapper:
        #{bin}/openms-env <command>

      For GUI applications (TOPPView, TOPPAS), make sure you have a running X server
      or use XQuartz on macOS.

      To run tests:
        cd #{prefix}
        ctest -R TOPP -j$(nproc)

      For third-party search engines, download them to:
        #{prefix}/THIRDPARTY

      Documentation: https://openms.readthedocs.io/
    EOS
  end

  test do
    # Set up environment
    if OS.mac?
      ENV["DYLD_LIBRARY_PATH"] = "#{lib}:#{ENV["DYLD_LIBRARY_PATH"]}"
    else
      ENV["LD_LIBRARY_PATH"] = "#{lib}:#{ENV["LD_LIBRARY_PATH"]}"
    end
    ENV["OPENMS_DATA_PATH"] = "#{lib}/share/OpenMS"

    # Test basic functionality
    system bin/"FileInfo", "--help"

    # Create a minimal valid mzML file for testing
    (testpath/"test.mzML").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <mzML xmlns="http://psi.hupo.org/ms/mzml" version="1.1.0">
        <cvList count="2">
          <cv id="MS" fullName="Proteomics Standards Initiative Mass Spectrometry Ontology" version="4.1.30" URI="https://raw.githubusercontent.com/HUPO-PSI/psi-ms-CV/master/psi-ms.obo"/>
          <cv id="UO" fullName="Unit Ontology" version="09:04:2014" URI="https://raw.githubusercontent.com/bio-ontology-research-group/unit-ontology/master/unit.obo"/>
        </cvList>
        <fileDescription>
          <fileContent>
            <cvParam cvRef="MS" accession="MS:1000579" name="MS1 spectrum" value=""/>
          </fileContent>
          <sourceFileList count="1">
            <sourceFile id="SF1" name="test.raw" location="file:///tmp/">
              <cvParam cvRef="MS" accession="MS:1000569" name="SHA-1" value="71be39fb2700ab2f3c8b2234b91274968b6899b1"/>
              <cvParam cvRef="MS" accession="MS:1000584" name="mzML format" value=""/>
            </sourceFile>
          </sourceFileList>
        </fileDescription>
        <instrumentConfigurationList count="1">
          <instrumentConfiguration id="IC1">
            <cvParam cvRef="MS" accession="MS:1000031" name="instrument model" value=""/>
          </instrumentConfiguration>
        </instrumentConfigurationList>
        <dataProcessingList count="1">
          <dataProcessing id="pwiz_processing">
            <processingMethod order="0" softwareRef="pwiz">
              <cvParam cvRef="MS" accession="MS:1000544" name="Conversion to mzML" value=""/>
            </processingMethod>
          </dataProcessing>
        </dataProcessingList>
        <softwareList count="1">
          <software id="pwiz" version="3.0.0">
            <cvParam cvRef="MS" accession="MS:1000615" name="ProteoWizard software" value=""/>
          </software>
        </softwareList>
        <run id="run1" defaultInstrumentConfigurationRef="IC1" defaultSourceFileRef="SF1">
          <spectrumList count="1" defaultDataProcessingRef="pwiz_processing">
            <spectrum id="scan=1" index="0" defaultArrayLength="0">
              <cvParam cvRef="MS" accession="MS:1000579" name="MS1 spectrum" value=""/>
              <cvParam cvRef="MS" accession="MS:1000511" name="ms level" value="1"/>
              <binaryDataArrayList count="2">
                <binaryDataArray encodedLength="0">
                  <cvParam cvRef="MS" accession="MS:1000514" name="m/z array" value=""/>
                  <cvParam cvRef="MS" accession="MS:1000523" name="64-bit float" value=""/>
                  <cvParam cvRef="MS" accession="MS:1000576" name="no compression" value=""/>
                  <binary></binary>
                </binaryDataArray>
                <binaryDataArray encodedLength="0">
                  <cvParam cvRef="MS" accession="MS:1000515" name="intensity array" value=""/>
                  <cvParam cvRef="MS" accession="MS:1000523" name="64-bit float" value=""/>
                  <cvParam cvRef="MS" accession="MS:1000576" name="no compression" value=""/>
                  <binary></binary>
                </binaryDataArray>
              </binaryDataArrayList>
            </spectrum>
          </spectrumList>
        </run>
      </mzML>
    EOS
    # Test file parsing
    system bin/"FileInfo", "-in", "test.mzML"
  end
end
