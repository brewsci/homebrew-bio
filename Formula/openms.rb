class Openms < Formula
  desc "Open-source software C++ library for LC-MS data management and analyses"
  homepage "https://www.openms.de/"
  url "https://github.com/OpenMS/OpenMS/archive/refs/tags/Release3.1.0.tar.gz"
  sha256 "083b647f9cf3a46b4104fac8632798084385889af434e851a46893a100ff2a85"
  license "BSD-3-Clause"
  
  head "https://github.com/OpenMS/OpenMS.git", branch: "develop"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "coinutils"
  depends_on "eigen"
  depends_on "glpk"
  depends_on "hdf5"
  depends_on "libsvm"
  depends_on "qt@5"
  depends_on "qt@6"
  depends_on "xerces-c"

  # Optional dependencies
  depends_on "doxygen" => :optional
  depends_on "openjdk" => :optional

  def install
    # Set up contrib directory
    system "git", "submodule", "update", "--init", "contrib" if build.head?
    
    # Build contrib libraries
    # mkdir "contrib_build" do
    #   system "cmake", 
    #          "-DBUILD_TYPE=ALL", 
    #          "-DNUMBER_OF_JOBS=#{ENV.make_jobs}",
    #          "-DCMAKE_CXX_COMPILER=#{ENV.cxx}",
    #          "-DCMAKE_C_COMPILER=#{ENV.cc}",
    #          buildpath/"contrib"
    #   system "make", "-j#{ENV.make_jobs}"
    # end

    # Build OpenMS
    mkdir "openms_build" do
      args = %W[
        -DCMAKE_CXX_COMPILER=#{ENV.cxx}
        -DCMAKE_C_COMPILER=#{ENV.cc}
        -DOPENMS_CONTRIB_LIBS=#{buildpath}/contrib_build
        -DCMAKE_PREFIX_PATH=#{Formula["qt@5"].opt_prefix}
        -DBOOST_USE_STATIC=OFF
        -DCMAKE_BUILD_TYPE=Release
        -DWITH_COINOR=ON
        -DCMAKE_INSTALL_PREFIX=#{prefix}
        -DWITH_GUI=ON
        -DENABLE_DOCS=#{build.with?("doxygen") ? "ON" : "OFF"}
        -DENABLE_UPDATE_CHECK=OFF
        -DGIT_TRACKING=OFF
      ]
      
      # Add Qt6 CMake path
      #args << "-DQt6_DIR=#{Formula["qt@6"].opt_lib}/cmake/Qt6"
      
      system "cmake", buildpath, *args
      system "make"
      system "make", "install"
    end

    # Create wrapper scripts to ensure proper library paths
    (bin/"openms-env").write <<~EOS
      #!/bin/bash
      export DYLD_LIBRARY_PATH="#{lib}:$DYLD_LIBRARY_PATH"
      export PATH="#{bin}:$PATH"
      exec "$@"
    EOS
    
    chmod 0755, bin/"openms-env"
  end

  def caveats
    <<~EOS
      OpenMS has been installed successfully!
      
      To use OpenMS tools, you may need to set up your environment:
        export PATH="#{bin}:$PATH"
        export DYLD_LIBRARY_PATH="#{lib}:$DYLD_LIBRARY_PATH"
      
      Or use the provided wrapper:
        #{bin}/openms-env <command>
      
      For GUI applications (TOPPView, TOPPAS), make sure you have a running X server
      or use XQuartz on macOS.
      
      To run tests:
        cd #{prefix}
        ctest -R TOPP -j#{ENV.make_jobs}
        
      For third-party search engines, download them to:
        #{prefix}/THIRDPARTY
        
      Documentation: https://openms.readthedocs.io/
    EOS
  end

  test do
    # Test basic functionality
    system bin/"FileInfo", "--help"
    
    # Test library loading
    system bin/"openms-env", "FileInfo", "--help"
    
    # Basic smoke test with a simple TOPP tool
    (testpath/"test.mzML").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <mzML xmlns="http://psi.hupo.org/ms/mzml" version="1.1.0">
        <cvList count="1">
          <cv id="MS" fullName="Proteomics Standards Initiative Mass Spectrometry Ontology" version="4.1.0" URI="https://raw.githubusercontent.com/HUPO-PSI/psi-ms-CV/master/psi-ms.obo"/>
        </cvList>
        <fileDescription>
          <fileContent>
            <cvParam cvRef="MS" accession="MS:1000579" name="MS1 spectrum" value=""/>
          </fileContent>
        </fileDescription>
        <run id="test_run">
          <spectrumList count="1">
            <spectrum id="scan=1" index="0" defaultArrayLength="3">
              <cvParam cvRef="MS" accession="MS:1000511" name="ms level" value="1"/>
              <cvParam cvRef="MS" accession="MS:1000579" name="MS1 spectrum" value=""/>
              <binaryDataArrayList count="2">
                <binaryDataArray encodedLength="32">
                  <cvParam cvRef="MS" accession="MS:1000514" name="m/z array" value=""/>
                  <cvParam cvRef="MS" accession="MS:1000523" name="64-bit float" value=""/>
                  <cvParam cvRef="MS" accession="MS:1000576" name="no compression" value=""/>
                  <binary>AAAAAAAA8D8AAAAAAAAAQAAAAAAAAAhA</binary>
                </binaryDataArray>
                <binaryDataArray encodedLength="32">
                  <cvParam cvRef="MS" accession="MS:1000515" name="intensity array" value=""/>
                  <cvParam cvRef="MS" accession="MS:1000523" name="64-bit float" value=""/>
                  <cvParam cvRef="MS" accession="MS:1000576" name="no compression" value=""/>
                  <binary>AAAAAAAAJEAAAAAAAAA0QAAAAAAAAERA</binary>
                </binaryDataArray>
              </binaryDataArrayList>
            </spectrum>
          </spectrumList>
        </run>
      </mzML>
    EOS
    
    # Test FileInfo with the test file
    system bin/"openms-env", "FileInfo", "-in", "test.mzML"
  end
end