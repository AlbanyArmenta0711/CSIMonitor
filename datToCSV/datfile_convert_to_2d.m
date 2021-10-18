% This script can make images from .dat file
clc;
clear all;
close all force;
FileName='wifitestAlbany.dat';
PathName='';
csi_trace = read_bf_file(strcat(PathName,FileName));

% Extract CSI information for each packet
fprintf('Have CSI for %d packets\n', length(csi_trace))

% Select packet
% csi_entry = csi_trace{1};

% Scaled into linear
csi = zeros(length(csi_trace),3,30);
timestamp = zeros(length(csi_trace));
for packet_index = 1:length(csi_trace)
    csi(packet_index,:,:) = get_scaled_csi(csi_trace{packet_index});
    timestamp(packet_index) = csi_trace{packet_index}.timestamp_low * 1.0e-6;
end
timestamp = timestamp';

% Plot csi amplitude
%figure;
%plot(db(abs(squeeze(csi(1,:,:)).')))
%legend('RX Antenna A', 'RX Antenna B', 'RX Antenna C', 'Location', 'SouthEast' );
%xlabel('Subcarrier index');
%ylabel('Amp [dB]');

%figure;
%plot(db(abs(squeeze(csi(:,:,1)))))
%legend('RX Antenna A', 'RX Antenna B', 'RX Antenna C', 'Location', 'SouthEast' );
%xlabel('Packet index');
%ylabel('Amp [dB]');

csi_surfplot = permute(db(abs(squeeze(csi))), [3 1 2]);
figure('Name','Amplitude');
subplot(3,1,1);
imagesc(csi_surfplot(:,:,1));
title('Antenna A','FontSize',20);
xlabel('Packet index','FontSize',20);
ylabel('Subcarrier index','FontSize',20);
colorbar;

subplot(3,1,2);
imagesc(csi_surfplot(:,:,2));
title('Antenna B','FontSize',20);
xlabel('Packet index','FontSize',20);
ylabel('Subcarrier index','FontSize',20); 
colorbar;

subplot(3,1,3);
imagesc(csi_surfplot(:,:,3));
title('Antenna C','FontSize',20);
xlabel('Packet index','FontSize',20);
ylabel('Subcarrier index','FontSize',20);
colormap(jet);
colorbar;
grid;

% Plot csi phase
%figure;
%plot(angle(squeeze(csi(1,:,:)).'))
%legend('RX Antenna A', 'RX Antenna B', 'RX Antenna C', 'Location', 'SouthEast' );
%xlabel('Subcarrier index');
%ylabel('Phase [rad]');

%figure;
%plot(angle(squeeze(csi(:,:,1))))
%legend('RX Antenna A', 'RX Antenna B', 'RX Antenna C', 'Location', 'SouthEast' );
%xlabel('Packet index');
%ylabel('Phase [rad]');

csi_angle_surfplot = permute(angle(squeeze(csi)), [3 1 2]); 
for i=1:size(csi_angle_surfplot,2)
    for j=1:size(csi_angle_surfplot,3)
        csi_angle_surfplot2(:,i,j) = phase_calibration(csi_angle_surfplot(:,i,j))';
    end
end
figure('Name','Sanitized Phase');
subplot(3,1,1);
imagesc(csi_angle_surfplot2(:,:,1));
title('Antenna A','FontSize',20);
xlabel('Packet index','FontSize',20);
ylabel('Subcarrier index','FontSize',20);
colorbar;

subplot(3,1,2);
imagesc(csi_angle_surfplot2(:,:,2));
title('Antenna B','FontSize',20);
xlabel('Packet index','FontSize',20);
ylabel('Subcarrier index','FontSize',20);
colorbar;

subplot(3,1,3);
imagesc(csi_angle_surfplot2(:,:,3));
title('Antenna C','FontSize',20);
xlabel('Packet index','FontSize',20);
ylabel('Subcarrier index','FontSize',20);
colormap(jet);
colorbar;
grid;

figure('Name','Phase');
subplot(3,1,1);
imagesc(csi_angle_surfplot(:,:,1));
title('Antenna A','FontSize',20);
xlabel('Packet index','FontSize',20);
ylabel('Subcarrier index','FontSize',20);
colorbar;

subplot(3,1,2);
imagesc(csi_angle_surfplot(:,:,2));
title('Antenna B','FontSize',20);
xlabel('Packet index','FontSize',20);
ylabel('Subcarrier index','FontSize',20);
colorbar;

subplot(3,1,3);
imagesc(csi_angle_surfplot(:,:,3));
title('Antenna C','FontSize',20);
xlabel('Packet index','FontSize',20);
ylabel('Subcarrier index','FontSize',20);
colormap(jet);
colorbar;
grid;
