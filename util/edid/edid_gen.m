%% Generator for Extended Display Identification Data(EDID) Structure Ver.1 Rev.3
% Sebastian Weiss <dl3yc@darc.de>

bytes = uint8(zeros(1,128));

%% 8 Bytes Header
bytes(1) = 0;
bytes(2) = 255;
bytes(3) = 255;
bytes(4) = 255;
bytes(5) = 255;
bytes(6) = 255;
bytes(7) = 255;
bytes(8) = 0;

%% 10 Bytes Vendor / Product Indentification
% ID Manufacturer Name(EISA 3-character ID)
% DAS
% D = 0b00100 A = 0b00001 S = 0x10011
bytes(9) = bin2dec('00010000');
bytes(10) = bin2dec('00110011');
% ID Product Code(Vendor assigned code)
bytes(11) = hex2dec('25');
bytes(12) = hex2dec('00');
% ID Serial Number(32-bit serial number)
bytes(13) = 1;
bytes(14) = 0;
bytes(15) = 0;
bytes(16) = 0;
% Week of Manufacture
bytes(17) = 37;
% Year of Manufacture
bytes(18) = 24;

%% 2 Bytes EDID Structure Version / Revision
bytes(19) = 1;
bytes(20) = 3;

%% 5 Bytes Basic Display Parameters / Features
% Video Input Definition
% Bit 7 - 0=Analog 1=Digital
% Bit 0 - DFP 1.x
bytes(21) = bin2dec('10000000');
% Max. Horizontal Image Size(cm)
bytes(22) = 100;
% Max. Vertical Image Size(cm)
bytes(23) = 100;
% Display Transfer Characteristic(Gamma)
bytes(24) = 255;
% Feature Support
% Bit 7 - Standby
% Bit 6 - Suspend
% Bit 5 - Active Off/Very Low Power
% Bit 4:3 - 0=Monochrome/Grayscale 1=RGB 2=Non-RGB 3=Undefined
% Bit 2 - Standard Default Color Space, sRGB
% Bit 1 - Preferred Timing Mode
% Bit 0 - Default GTF supported
bytes(25) = bin2dec('00001010');

%% 10 Bytes Color Characteristics
% Red/Green Low Bits
% Blue/White Low Bits
% Red-x
% Red-y
% Green-x
% Green-y
% Blue-x
% Blue-y
% White-x
% White-y

%% 3 Bytes Established Timings
bytes(36) = 0;
bytes(37) = 0;
bytes(38) = 0;

%% 16 Bytes Standard Timing Identification
% Horizontal active pixel / 8 - 31
bytes(39) = 1;
% Image Aspect Ratio Bits 7:6 0=16:10 1=4:3 2=5:3 3=16:9
% Refresh Rate - 60
bytes(40) = 1;
bytes(41) = 1;
bytes(42) = 1;
bytes(43) = 1;
bytes(44) = 1;
bytes(45) = 1;
bytes(46) = 1;
bytes(47) = 1;
bytes(48) = 1;
bytes(49) = 1;
bytes(50) = 1;
bytes(51) = 1;
bytes(52) = 1;
bytes(53) = 1;
bytes(54) = 1;
% we don't support standard timing

%% 72 Bytes Detailed Timing Descriptions
% 18 Bytes Detailed Timing Description #1
% 2 Bytes Pixel clock / 10000(LSByte first)
% 27MHz is 2700 decimal, stored as 0x8C, 0x0A
bytes(55) = hex2dec('8C');
bytes(56) = hex2dec('0A');
% 1 Byte Horizontal Active Pixels(lower 8 bits)
% 1440 active horizontal pixel -> 0x5A0
bytes(57) = hex2dec('A0');
% 1 Byte Horizontal Blanking(lower 8 bits)
% 154px Blanking
bytes(58) = 154;
% 1 Byte Horizontal Active Pixels / Horizontal Blanking
% Upper nibble: upper 4 bits of Horizontal Active
% Lower nibble: upper 4 bits of Horizontal Blanking
bytes(59) = hex2dec('50');
% 1 Byte Vertical Active Lines(lower 8 bits)
% 576 active vertical Lines -> 0x240
bytes(60) = hex2dec('40');
% 1 Byte Vertical Blanking(lower 8 bits)
% 15 lines Blanking
bytes(61) = 15;
% 1 Byte Vertical Active Lines / Vertical Blanking
% Upper nibble: upper 4 bits of Vertical Active
% Lower nibble: upper 4 bits of Vertical Blanking
bytes(62) = hex2dec('20');
% 1 Byte Horizontal Sync. Offset(lower 8 bits)
bytes(63) = 0;
% 1 Byte Horizontal Sync. Pulse Width(lower 8 bits)
bytes(64) = 1;
% 1 Byte Vertical Sync. Offset / Vertical Sync. Pulse Width
% Upper nibble: upper 4 bits of Offset (lower 4 bits)
% Lower nibble: upper 4 bits of Pulse Width (lower 4 bits)
bytes(65) = hex2dec('01');
% 1 Byte Byte Horizontal & Vertical Sync. Offset & Pulse Width
% Bits 7:6 upper 2 bits of Horizontal Sync. Offset
% Bits 5:4 upper 2 bits of Horizontal Sync. Pulse Width
% Bits 3:2 upper 2 bits of Vertical Sync. Offset
% Bits 1:0 upper 2 bits of Vertical Sync. Pulse Width
bytes(66) = 0;
% Horizontal Image Size(in mm) lower 8 bits
bytes(67) = 10;
% Vertical Image Size(in mm) lower 8 bits
bytes(68) = 10;
% Horizontal / Vertical Image Size(upper 4 bits)
bytes(69) = 0;
% Horizontal Border
% for active Blanking
bytes(70) = 22;
% Vertical Border
bytes(71) = 0;
% Flags
% Bit 7 Interlaced
% Bits 6:5 0=Normal Display others for stereo
% Bits 4:3 0=Analog Composite 1=Bipolar Analog Composite
%          2=Digital Composite 3=Digital seperate
% Bit 2 Vertical Polarity
% Bit 1 Horizontal Polarity
bytes(72) = bin2dec('10011000');

%% 18 Byte Monitor Descriptor Block
bytes(73) = 0;
bytes(74) = 0;
bytes(75) = 0;
% Data Type Tag
% 0xFF: Monitor Serial Number(ASCII)
% 0xFE: ASCII String(ASCII)
% 0xFD: Monitor range limits, binary coded
% 0xFC: Monitor name(ASCII)
% 0xFB: Descriptor contains additional color point data
% 0xFA: Descriptor contains additional Standard Timing Identification
% 0x10: Descriptor is unused
bytes(76) = hex2dec('FC');
bytes(77) = 0;
bytes(78) = uint8('D');
bytes(79) = uint8('A');
bytes(80) = uint8('S');
bytes(81) = uint8(' ');
bytes(82) = uint8('D');
bytes(83) = uint8('B');
bytes(84) = uint8('0');
bytes(85) = uint8('H');
bytes(86) = uint8('L');
bytes(87) = hex2dec('A');

bytes(91) = 0;
bytes(92) = 0;
bytes(93) = 0;
bytes(94) = hex2dec('FD');
bytes(95) = 0;
bytes(96) = 50;
bytes(97) = 50;
bytes(98) = 15;
bytes(99) = 32;
bytes(100) = 3;

bytes(109) = 0;
bytes(110) = 0;
bytes(111) = 0;
bytes(112) = hex2dec('FE');
bytes(113) = 0;
bytes(114) = uint8('D');
bytes(115) = uint8('L');
bytes(116) = uint8('3');
bytes(117) = uint8('Y');
bytes(118) = uint8('C');
bytes(119) = hex2dec('A');

%% Checksum
bytes(128) = 256 - mod(sum(bytes),256);

fid = fopen('edid.bin', 'w');
fwrite(fid, bytes, 'uint8');
fclose(fid);
