echo "Creating a cache directory..."
mkdir -p ~/.cache/aoe2fix
cd ~/.cache/aoe2fix

VC_REDIST="https://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x64.exe"

echo $VC_REDIST

echo "Downloading Visual C++ Redistributable..."
if [ -x "$(command -v wget)" ]; then
  wget $VC_REDIST
elif [ -x "$(command -v axel)" ]; then
  axel -n 8 $VC_REDIST
elif [ -x "$(command -v curl)" ]; then
  curl -O $VC_REDIST
else
  echo "wget, axel or curl not found. Installing wget..."
  yes | sudo pacman -Syu wget >> /dev/null
  wget $VC_REDIST
fi

if [ ! -f vc_redist.x64.exe ]; then
  echo "Visual C++ Redistributable could not be downloaded."
  exit 1
else
  echo "Visual C++ Redistributable has been downloaded."
fi

if [ ! -x "$(command -v cabextract)" ]; then
  HAS_CABEXTRACT_INSTALLED=true
  echo "Installing cabextract to extract Visual C++ Redistributable..."
  yes | sudo pacman -Syu cabextract >> /dev/null
fi

echo "Extracting Visual C++ Redistributable..."
cabextract vc_redist.x64.exe >> /dev/null
cabextract a10 >> /dev/null

if [ "$HAS_CABEXTRACT_INSTALLED" = true ]; then
  echo "Removing cabextract..."
  yes | sudo pacman -Rncs cabextract >> /dev/null
fi

echo "Installing Visual C++ Redistributable..."
chmod u+w ~/.steam/steam/steamapps/compatdata/813780/pfx/drive_c/windows/system32/ucrtbase.dll
yes | cp ucrtbase.dll ~/.steam/steam/steamapps/compatdata/813780/pfx/drive_c/windows/system32
echo "Removing cache directory..."
cd ..
rm -rf aoe2fix

echo "Visual C++ Redistributable has been installed."
