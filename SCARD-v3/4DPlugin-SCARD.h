/* --------------------------------------------------------------------------------
 #
 #	4DPlugin-SCARD.h
 #	source generated by 4D Plugin Wizard
 #	Project : SCARD
 #	author : miyako
 #	2021/11/04
 #  
 # --------------------------------------------------------------------------------*/

#ifndef PLUGIN_SCARD_H
#define PLUGIN_SCARD_H

#include "4DPluginAPI.h"
#include "4DPlugin-JSON.h"
#include "json/json.h"

#if VERSIONMAC
#import <Cocoa/Cocoa.h>
#import <CryptoTokenKit/CryptoTokenKit.h>
#include "libusb-1.0/libusb.h"
/* libusb */
#define LIBUSB_DATASIZE 255
#define LIBUSB_USLEEP_DURATION 250000 //microseconds
#define LIBUSB_API_TIMEOUT 2000  //milliseconds
#define LIBUSB_API_TIMEOUT_FOR_POLLING 500 //milliseconds
#define LIBUSB_MAX_STRING_LENGTH 512
#define LIBUSB_SONY_RC_S380 0x06C3
/* SONY PaSoRi */
#define LIBUSB_SONY 0x054C
#define LIBUSB_SONY_RC_S330 0x02E1
#define LIBUSB_SONY_RC_S320 0x01BB
#define LIBUSB_SONY_RC_S310 0x006C
struct device_info {
  libusb_device *dev;
  libusb_device_handle *dh;
  uint8_t ep_in;
  uint8_t ep_out;
  int interface_num;
};
typedef device_info usb_device_info;
static bool checkAccess(PA_ObjectRef status);
/* libpafe */
#include "libpafe.h"
#include "pasori_command.h"
#include "felica_command.h"
#endif

#include <iostream>
#include <thread>
#include <mutex>
#include <future>

#pragma mark -

static void SCARD_Get_readers(PA_PluginParameters params);
static void SCARD_Read_tag(PA_PluginParameters params);
static void SCARD_Get_status(PA_PluginParameters params);

#pragma mark -

static short checksum(char cmd, uint8_t *buf, int size);
static void u16_to_u8(CUTF16String& u16, std::string& u8);
static void u8_to_u16(std::string& u8, CUTF16String& u16);
enum
{
    APDU_CLA_GENERIC = 0xFF,
    
    APDU_INS_GET_DATA = 0xCA,
    APDU_INS_READ_BINARY = 0xB0,
    APDU_INS_UPDATE_BINARY = 0xD6,
    APDU_INS_DATA_EXCHANGE = 0xFE,
    APDU_INS_SELECT_FILE = 0xA4,
    
    APDU_P1_GET_UID = 0x00,
    APDU_P1_GET_PMm = 0x01,
    APDU_P1_GET_CARD_ID = 0xF0,
    APDU_P1_GET_CARD_NAME = 0xF1,
    APDU_P1_GET_CARD_SPEED = 0xF2,
    APDU_P1_GET_CARD_TYPE = 0xF3,
    APDU_P1_GET_CARD_TYPE_NAME = 0xF4,
    APDU_P1_NFC_DEP_TARGET_STATE = 0xF9,
    APDU_P1_THRU = 0x00,
    APDU_P1_DIRECT = 0x01,
    APDU_P1_NFC_DEP = 0x02,
    APDU_P1_DESELECT = 0xFD,
    APDU_P1_RELEASE = 0xFE,
    
    APDU_P2_NONE = 0x00,
    APDU_P2_TIMEOUT_AUTO = 0x00,
    APDU_P2_TIMEOUT_50MS = 0x05,
    APDU_P2_TIMEOUT_INFINITY = 0xFF,
    
    APDU_LE_MAX_LENGTH = 0x00,
    
    EXCHANGE_POLLING_PACKET_SIZE = 5,
    EXCHANGE_POLLING = 0x00,
    
    POLLING_REQUEST_SYSTEM_CODE = 0x01,
    POLLING_TIMESLOT_16 = 0x0F,
    
    SYSTEMCODE_ANY = 0xFFFF,
    SYSTEMCODE_FELICALITE = 0x88B4,
    SYSTEMCODE_NFC_TYPE3 = 0x12FC
};

enum
{
    CARD_TYPE_UNKNOWN = 0x00,
    CARD_TYPE_ISO14443A = 0x01,
    CARD_TYPE_ISO14443B = 0x02,
    CARD_TYPE_PICOPASSB = 0x03,
    CARD_TYPE_FELICA = 0x04,
    CARD_TYPE_NFC_TYPE_1 = 0x05,
    CARD_TYPE_MIFARE_EC = 0x06,
    CARD_TYPE_ISO14443A_4A = 0x07,
    CARD_TYPE_ISO14443B_4B = 0x08,
    CARD_TYPE_TYPE_A_NFC_DEP = 0x09,
    CARD_TYPE_FELICA_NFC_DEP = 0x0A
};

struct __tag__sinfo
{
  int c;
  char *d;
};
typedef struct __tag__sinfo sinfo;

#endif /* PLUGIN_SCARD_H */
