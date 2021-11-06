#define FELICA_POLLING_ANY   0xffff
#define FELICA_POLLING_SUICA 0x0003
#define FELICA_POLLING_EDY   0xfe00
#define FELICA_CMD_POLLING 0
#define L8(x) (x & 0xff)
#define H8(x) ((x >> 8) & 0xff)
static uint8_t S330_RF_ANTENNA_ON[] = { 0xD4, 0x32, 0x01, 0x01 };
static uint8_t S330_RF_ANTENNA_OFF[] = { 0xD4, 0x32, 0x01, 0x00 };
static uint8_t S330_DESELECT[] = { 0xD4, 0x44, 0x01 };


static int pasori_checksum(uint8_t *data, int size) {
    
  int i, sum = 0;

  if (data == NULL)
    return 0;

  for (i = 0; i != size; i++) {
    sum += data[i];
  }
  sum &= 0xff;
  sum = 0x100 - sum;

  return sum & 0xff;
}

static int pasori_send(usb_device_info *devinfo, uint8_t *buf, int size, int timeout) {
    
    uint8_t rcv[LIBUSB_DATASIZE];
    
    int len;
    int ret;

    ret = libusb_bulk_transfer(devinfo->dh, devinfo->ep_out,
                               (unsigned char *)buf, size,
                               &len, timeout);
    if(ret < 0){
        std::cout << "data send error..." << std::endl;
        return -1;
    }
    
    ret = libusb_bulk_transfer(devinfo->dh, devinfo->ep_in,
                               (unsigned char *)rcv, sizeof(rcv),
                               &len, timeout);
    if(ret){
        std::cout << "data receive error..." << std::endl;
        return -1;
    }
    
    if (len != 6){
        std::cout << "ack receive error..." << std::endl;
        return -1;
    }
    
    if (rcv[4] != 0xff) {
        std::cout << "ack receive error..." << std::endl;
        return -1;
    }
    
    return 0;
}

static int pasori_recv(usb_device_info *devinfo, uint8_t *data, int *len, int timeout) {
        
    int size = *len;
    int ret;
    
    ret = libusb_bulk_transfer(devinfo->dh, devinfo->ep_in,
                               (unsigned char *)data, size,
                               len, timeout);
    
    if(ret){
        std::cout << "recv error..." << std::endl;
        return ret;
    }
        
    return 0;
}

static int pasori_packet_write(usb_device_info *devinfo, uint8_t *buf, int size, int timeout) {
    
    uint8_t cmd[LIBUSB_DATASIZE + 1];
    int n;
    short csum;
    
    n = size;
    if(n < 1) return 0;
    
    if (n > LIBUSB_DATASIZE - 7)
      n = LIBUSB_DATASIZE - 7;
    
    csum = pasori_checksum(buf, size);
    
    cmd[0] = 0;
    cmd[1] = 0;;
    cmd[2] = 0xff;
    cmd[3] = n;
    cmd[4] = 0x100 - n;
    memcpy(cmd + 5, buf, n);
    cmd[5 + n] = csum;
    cmd[6 + n] = 0;
    n += 7;
    
    return pasori_send(devinfo, cmd, n, timeout);
}

static int pasori_packet_read(usb_device_info *devinfo, std::vector<uint8_t> *usbbuf, size_t *n, int timeout) {
        
    uint8_t rbuf[LIBUSB_DATASIZE];
    
    int len = sizeof(rbuf);
    
    int i = pasori_recv(devinfo, rbuf, &len, timeout);
 
    if (i)
      return i;
    
    if (rbuf[0] != 0 || rbuf[1] != 0 || rbuf[2] != 0xff)
      return -1;
    
    if (rbuf[5] == 0x7f)
      return -1;
    
    unsigned int s = rbuf[3];
    if (rbuf[4] != 0x100 - s)
        return -1;
    
    int sum = pasori_checksum(rbuf + 5, s);
    if (rbuf[s + 5] != sum)
      return -1;
    
    if (rbuf[s + 6] != 0)
      return -1;
    
    if(s > usbbuf->size()) {
        usbbuf->resize(s);
    }
    
    memcpy(&usbbuf->at(0), &rbuf[5], s);
    
    *n = len;
    
    return 0;
}

static int pasori_init_test(usb_device_info *devinfo, uint8_t *buf, int size, int timeout) {
    
    uint8_t recv[LIBUSB_DATASIZE + 1];
    
    int ret = pasori_packet_write(devinfo, buf, size, timeout);
    
    if (ret)
      return ret;
    
    int len = sizeof(recv);
    
    ret = pasori_recv(devinfo, recv, &len, timeout);

    return ret;
}
    
static int pasori_read(usb_device_info *devinfo, std::vector<uint8_t> *usbbuf, int timeout) {
 
    std::vector<uint8_t>recv(LIBUSB_DATASIZE);
       
    int ret;
    size_t n;
   
    ret = pasori_packet_read(devinfo, &recv, &n, timeout);
    
    if (ret)
      return ret;
    
    if (recv[0] != 0xd5)
        return -1;
        
    if(n > usbbuf->size()) {
        n = usbbuf->size();
    }

    memcpy(&usbbuf->at(0), &recv.at(2), n);

    return 0;
}

static size_t pasori_list_passive_target(usb_device_info *devinfo, uint8_t *buf, int size, int timeout) {
    
    unsigned char cmd[LIBUSB_DATASIZE];
    
    cmd[0] = 0xd4;
    cmd[1] = 0x4a;
    cmd[2] = 1;
    cmd[3] = 0x01;
    
    memcpy(cmd + 4, buf, size);
    
    int n = size + 4;
        
    return pasori_packet_write(devinfo, cmd, n, timeout);
}

static size_t felica_polling(usb_device_info *devinfo, char type,
                                std::vector<uint8_t> *usbbuf, int timeout) {
        
    uint8_t cmd[5];
    
    if(type == 'F') {
        cmd[0] = (uint8) FELICA_CMD_POLLING;
        cmd[1] = H8(FELICA_POLLING_ANY);
        cmd[2] = L8(FELICA_POLLING_ANY);
        cmd[3] = 0;
        cmd[4] = 1;
    }
        
    pasori_list_passive_target(devinfo, cmd, sizeof(cmd), timeout);
    
    
    return pasori_read(devinfo, usbbuf, timeout);
}

