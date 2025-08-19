mkdir -p ~/.build
for i in {1..3}; do
  git clone https://github.com/AdnanHodzic/auto-cpufreq.git ~/.build/auto-cpufreq && break
  rm -rf ~/.build/auto-cpufreq
  sleep 3
done
sudo ~/.build/auto-cpufreq/auto-cpufreq-installer --install
sudo /usr/local/bin/auto-cpufreq --install
