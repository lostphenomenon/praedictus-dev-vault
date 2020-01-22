# The following scripts help with live debugging of linux services
 sudo journalctl -fu  servicename.service
 sudo journalctl -u servicename.service --no-pager

# the argument is the systemd service descriptor file, this will display live output from the service

systemctl start serviceName.service
systemctl stop serviceName.service
systemctl daemon-reload

# invoke healthcheck::
curl -vs http://localhost:5007/api/health 2>&1 | less

# check if something is blocking a port:
sudo netstat -tulpn | grep :5007
sudo kill 123456

	# Remove service if address is already in use:
	sudo systemctl stop servicename.service
	sudo systemctl disable servicename.service
	sudo rm /etc/systemd/system/servicename.service
	sudo systemctl daemon-reload
	sudo systemctl reset-failed
	systemctl list-unit-files | grep -i nrgs_admin

# try to read logs and cat them to console
find . -type f -name "*.log" -exec cat {} +

# kill the process listening on the application port (sometimes it gets stuck)
echo -e "[OK] Killing child process of dotnet because it seems to be stuck..."
fuser -k -n tcp $applicationPort || echo "[FAIL] Couldnt stop application, either nothing is listening on $applicationPort or insufficent rights"