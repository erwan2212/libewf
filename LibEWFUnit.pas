unit LibEWFUnit;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{/*
  * Module providing Delphi bindings for the Library for the Expert Witness Compression Format Support (libewf.dll)
  *
  * Copyright (c) 2010, Brendan Berney <brendan@e-bren.net>,
  *
  * This software is free software: you can redistribute it and/or modify
  * it under the terms of the GNU Lesser General Public License as published by
  * the Free Software Foundation, either version 3 of the License, or
  * (at your option) any later version.
  *
  * This software is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU Lesser General Public License
  * along with this software.  If not, see <http://www.gnu.org/licenses/>.
  */}

    {/*
    * modified by Erwan LABALEC (erwan2212@gmail.com - http://erwan.labalec.fr/
    */}

interface

uses
  Windows,
  sysutils,classes ;

type

  {/*
    * LibEWF var and function type declarations - these are current for version 20070717
    */}

  {/*
    * added by Erwan LABALEC support for libewf v2.0.0.0 (20131210)
    */}

  TINT16 = short;
  TUINT16 = word;
  TUINT8 = byte;
  PLIBEWFHDL = pointer;
  TSIZE = longword;
  TSIZE64 = int64;
  PSIZE64 = ^int64;
  TARRPCHAR = array of pansiChar;
  PARRPCHAR = ^TARRPCHAR;

  TLibEWFCheckSig = function(filename : pansiChar) : integer; cdecl;
  TLibEWFOpen = function(filenames : TARRPCHAR; amount_of_files : TUINT16; flags : TUINT8) : PLIBEWFHDL; cdecl;
  TLibEWFReadRand = function(handle : PLIBEWFHDL; buffer : pointer; size : TSIZE; offset : TSIZE64) : integer; cdecl;
  Tlibewfhandlewriterand = function(handle : PLIBEWFHDL; buffer : pointer; size : TSIZE; offset : TSIZE64) : integer; cdecl;
  TLibEWFParseHdrVals = function(handle : PLIBEWFHDL; date_format : TUINT8) : integer; cdecl;
  TLibEWFGetMediaSize = function(handle : PLIBEWFHDL; media_size : PSIZE64) : integer; cdecl;
  TLibEWFClose = function(handle : PLIBEWFHDL) : TINT16; cdecl;
  //v2 functions
  Tlibewfhandleopen=function(handle : PLIBEWFHDL;filenames : TARRPCHAR; amount_of_files : integer; flags : integer;error:pointer) : integer; cdecl;
  Tlibewfhandleinitialize=function(handle : PLIBEWFHDL;error:pointer) : integer; cdecl; //pointer to PLIBEWFHDL
  Tlibewfhandlefree=function(handle : PLIBEWFHDL;error:pointer) : integer; cdecl;  //pointer to PLIBEWFHDL
  Tlibewfhandleclose=function(handle : PLIBEWFHDL;error:pointer) : integer; cdecl;

  Tlibewfhandlereadbuffer        = function(handle : PLIBEWFHDL; buffer : pointer; size : TSIZE; error:pointer) : integer; cdecl;
  Tlibewfhandlereadbufferatoffset = function(handle : PLIBEWFHDL; buffer : pointer; size : TSIZE; offset : TSIZE64;error:pointer) : integer; cdecl;
  Tlibewfhandlewritebuffer = function(handle : PLIBEWFHDL; buffer : pointer; size : TSIZE; error:pointer) : integer; cdecl;
  Tlibewfhandlewritebufferatoffset = function(handle : PLIBEWFHDL; buffer : pointer; size : TSIZE; offset : TSIZE64;error:pointer) : integer; cdecl;

  Tlibewfhandlegetmediasize = function(handle : PLIBEWFHDL; media_size : PSIZE64;error:pointer) : integer; cdecl;
  //Tlibewfhandlepreparewritechunk = function(handle : PLIBEWFHDL; buffer : pointer; buffer_size : TSIZE; compressed_buffer:pointer;compressed_size:tsize;is_compressed:tuint8;checksum:integer;write_checksum:tuint8; error:pointer) : integer; cdecl;
  //Tlibewfhandlewritechunk = function(handle : PLIBEWFHDL; buffer : pointer; chunk_size : TSIZE; data_size : TSIZE; is_compressed:tuint8;checksum_buffer:pointer;checksum:integer;write_checksum:tuint8; error:pointer) : integer; cdecl;
  Tlibewfhandlesetcompressionvalues= function(handle : PLIBEWFHDL; compression_level:TUINT8;compression_flags:TUINT8 ; error:pointer) : integer; cdecl;
  Tlibewfhandlesetutf8headervalue= function(handle : PLIBEWFHDL;identifier:pansichar;identifier_length:TSIZE;utf8_string:pansichar;utf8_string_length:TSIZE; error:pointer) : integer; cdecl;
  Tlibewfhandlegetutf8headervalue= function(handle : PLIBEWFHDL;identifier:pansichar;identifier_length:TSIZE;utf8_string:pansichar;utf8_string_length:TSIZE; error:pointer) : integer; cdecl;
  Tlibewfhandlegetutf8hashvalue= function(handle : PLIBEWFHDL;identifier:pansichar;identifier_length:TSIZE;utf8_string:pansichar;utf8_string_length:TSIZE; error:pointer) : integer; cdecl;

   // Added by SMITH for better fault detection in the event of BytesWrite failure
  TLibEWFErrorSPrint             = function (error: pointer; str: pchar; size: TSIZE) : TINT16; cdecl;

  {/*
    * TLibEWF - class providing Delphi bindings to a subset of libewf functions (only those required for reading at present).
    */}

      {/*
    * added by Erwan LABALEC
    -non deprecated function (libewf_handle_*)
    -writing
    -set compression
    -get/set header

    */}
  TLibEWF = class(TObject)
  private
        fLibHandle : THandle;
        fCurEWFHandle : PLIBEWFHDL;

        fLibEWFCheckSig : TLibEWFCheckSig;
        fLibEWFOpen : TLibEWFOpen;
        fLibEWFReadRand : TLibEWFReadRand;
        fLibEWFWriteRand : TLibEWFReadRand;
        fLibEWFGetSize : TLibEWFGetMediaSize;
        fLibEWFParseHdrVals : TLibEWFParseHdrVals;
        fLibEWFClose : TLibEWFClose;
        //v2
        flibewfhandleopen:Tlibewfhandleopen ;
        flibewfhandleclose:Tlibewfhandleclose ;
        flibewfhandleinitialize:Tlibewfhandleinitialize ;
        flibewfhandlefree:Tlibewfhandlefree ;

        flibewfhandlereadbuffer : Tlibewfhandlereadbuffer;
        flibewfhandlereadbufferatoffset:Tlibewfhandlereadbufferatoffset;
        flibewfhandlewritebuffer:Tlibewfhandlewritebuffer;
        flibewfhandlewritebufferatoffset:Tlibewfhandlewritebufferatoffset;  
        flibewfhandlegetmediasize:Tlibewfhandlegetmediasize;
        //flibewfhandlepreparewritechunk:Tlibewfhandlepreparewritechunk;
        //flibewfhandlewritechunk:Tlibewfhandlewritechunk;
        flibewfhandlesetcompressionvalues:Tlibewfhandlesetcompressionvalues;
        flibewfhandlesetutf8headervalue:Tlibewfhandlesetutf8headervalue;
        flibewfhandlegetutf8headervalue:Tlibewfhandlegetutf8headervalue;
        flibewfhandlegetutf8hashvalue:Tlibewfhandlegetutf8hashvalue;

        fLibEWFErrorSPrint : TLibEWFErrorSPrint;

  public
        constructor create();
        destructor destroy(); override;
        function libewf_check_file_signature(const filename : ansistring) : integer;
        function libewf_open(const filename : ansistring;flag:byte=$1) : integer;

        function libewf_read_buffer_at_offset(buffer : pointer; size : longword; offset : int64) : integer;
        function libewf_handle_read_buffer(Buffer : Pointer; size : longword) : integer;
        function libewf_write_buffer(buffer : pointer; size : longword) : integer;
        function libewf_write_buffer_at_offset(buffer : pointer; size : longword; offset : int64) : integer;
        function libewf_get_media_size() : int64;
        function libewf_parse_header_values_deprecated(date_format : byte) : integer;
        function libewf_close() : integer;
        function libewf_SetCompressionValues(level,flags:byte) : integer;
        function libewf_SetHeaderValue(identifier,value:ansistring) : integer;
        function libewf_GetHeaderValue(identifier:ansistring;var value:ansistring) : integer;
        function libewf_GetHashValue(identifier:ansistring;var value:ansistring) : integer;
  end;

const
        LIBEWF_OPEN_READ = $01;
        LIBEWF_OPEN_WRITE = $02;
        LIBEWF_DATE_FORMAT_DAYMONTH = $01;
        LIBEWF_DATE_FORMAT_MONTHDAY = $02;
        LIBEWF_DATE_FORMAT_ISO8601 = $03;
        LIBEWF_DATE_FORMAT_CTIME = $04;
        LIBEWF_VERSION='V2';

      	LIBEWF_COMPRESS_FLAG_USE_EMPTY_BLOCK_COMPRESSION	=  $01;
      	LIBEWF_COMPRESS_FLAG_USE_PATTERN_FILL_COMPRESSION	=  $02;

        LIBEWF_COMPRESSION_METHOD_NONE				= 0;
      	LIBEWF_COMPRESSION_METHOD_DEFLATE			= 1;
      	LIBEWF_COMPRESSION_METHOD_BZIP2				= 2;



implementation

{/*
  * Constructs a LibEWF object instance (also loads the library).
  */}
constructor TLibEWF.create();
var
        libFileName : ansistring;
begin
        fLibHandle:=0;
        fCurEWFHandle:=nil;

        //libFileName:=ExtractFilePath(Application.ExeName)+'libewf.dll';//-new.dll';
        libFileName:=ExtractFilePath(paramstr(0))+'libewf.dll';//-new.dll';
        if fileExists(libFileName) then
        begin
                fLibHandle:=LoadLibraryA(PAnsiChar(libFileName));
                if fLibHandle<>0 then
                begin
                        //v2
                        @flibewfhandleinitialize:=GetProcAddress(fLibHandle,'libewf_handle_initialize');
                        @flibewfhandlefree:=GetProcAddress(fLibHandle,'libewf_handle_free');
                        @flibewfhandleopen:=GetProcAddress(fLibHandle,'libewf_handle_open');
                        @flibewfhandleclose:=GetProcAddress(fLibHandle,'libewf_handle_close');
                        //@flibewfhandlereadrandom:=GetProcAddress(fLibHandle,'libewf_handle_read_random');   //->libewf_handle_read_buffer_at_offset
                        //@flibewfhandlewriterandom:=GetProcAddress(fLibHandle,'libewf_handle_write_random'); //->libewf_handle_write_buffer_at_offset

                        @flibewfhandlereadbuffer:=GetProcAddress(fLibHandle, 'libewf_handle_read_buffer');
                        @flibewfhandlereadbufferatoffset:=GetProcAddress(fLibHandle,'libewf_handle_read_buffer_at_offset');
                        if @flibewfhandlereadbufferatoffset=nil then @flibewfhandlereadbufferatoffset :=GetProcAddress(fLibHandle,'libewf_handle_read_random');
                        @flibewfhandlewritebuffer:=GetProcAddress(fLibHandle,'libewf_handle_write_buffer');
                        @flibewfhandlewritebufferatoffset:=GetProcAddress(fLibHandle,'libewf_handle_write_buffer_at_offset');

                        @flibewfhandlegetmediasize:=GetProcAddress(fLibHandle,'libewf_handle_get_media_size');
                        //@flibewfhandlepreparewritechunk:=GetProcAddress(fLibHandle,'libewf_handle_prepare_write_chunk');
                        //@flibewfhandlewritechunk:=GetProcAddress(fLibHandle,'libewf_handle_write_chunk');
                        @flibewfhandlesetcompressionvalues:=GetProcAddress(fLibHandle,'libewf_handle_set_compression_values');
                        @flibewfhandlesetutf8headervalue:=GetProcAddress(fLibHandle,'libewf_handle_set_utf8_header_value');
                        @flibewfhandlegetutf8headervalue:=GetProcAddress(fLibHandle,'libewf_handle_get_utf8_header_value');
                        @flibewfhandlegetutf8hashvalue:=GetProcAddress(fLibHandle,'libewf_handle_get_utf8_hash_value');
                        //V1
                        @fLibEWFCheckSig:=GetProcAddress(fLibHandle,'libewf_check_file_signature');
                        @fLibEWFOpen:=GetProcAddress(fLibHandle,'libewf_open');
                        @fLibEWFReadRand:=GetProcAddress(fLibHandle,'libewf_read_random');
                        @fLibEWFWriteRand:=GetProcAddress(fLibHandle,'libewf_write_random');
                        @fLibEWFGetSize:=GetProcAddress(fLibHandle,'libewf_get_media_size');
                        @fLibEWFParseHdrVals:=GetProcAddress(fLibHandle,'libewf_parse_header_values');
                        @fLibEWFClose:=GetProcAddress(fLibHandle,'libewf_close');

                        // Added by Smith 2015 for better fault reporting in the event of write failure to image
                        @fLibEWFErrorSPrint:=GetProcAddress(fLibHandle,'_libewf_error_backtrace_sprint');
                 end;
        end
        else raise exception.Create ('could not find libewf.dll');
end;

destructor TLibEWF.destroy();
begin
        if (fCurEWFHandle<>nil) then
        begin
                libewf_close();
                FreeLibrary(fLibHandle);
        end;
        inherited;
end;

{/*
  * Checks if the supplied file is a valid EWF file.
  * @param filename - the filename (of the specific part (e01, e02 etc.)).
  * @return 0 if successful and valid, -1 otherwise.
  */}
function TLibEWF.libewf_check_file_signature(const filename : ansistring) : integer;
begin
        Result:=0;
        if fLibHandle<>0 then
        begin
                Result:=fLibEWFCheckSig(pansiChar(filename));
        end;
end;

{/*
  * Open an entire (even multipart) EWF file.
  * @param filename - the first (.e01) file name.
  * @return 0 if successful and valid, -1 otherwise.
  */}
function TLibEWF.libewf_open(const filename : ansistring;flag:byte=$1) : integer;
var
        filenames : TStringList;
        fileNamePChars : TARRPCHAR;
        pFileNamePChars : PARRPCHAR;
        filenameRoot,curFilename : ansistring;
        fCount : integer;
        err:pointer;
        ret:integer;
begin
        err:=nil;
        Result:=-1;
        filenames:=TStringList.Create;
        try
                if fLibHandle<>0 then
                begin
                        filenameRoot:=Copy(filename,1, Length(filename)-4);
                        curFilename:=filenameRoot+'.E01';
                        while FileExists(curFilename) do
                        begin
                                if libewf_check_file_signature(curFilename)=1 then
                                        filenames.Add(curFilename)
                                else
                                        break;
                                curFilename:=filenameRoot+'.E'+Format('%.2d',[filenames.Count+1]);
                        end;
                        if flag=$2 then filenames.Add(filenameRoot);
                        SetLength(fileNamePChars, filenames.Count);
                        for fCount:=0 to filenames.Count-1 do
                                fileNamePChars[fCount]:=pansiChar(ansistring(filenames[fCount]));
                        fCurEWFHandle:=nil;err:=nil;
                        if LIBEWF_VERSION='V1'
                          then fCurEWFHandle:=fLibEWFOpen(fileNamePChars, Length(fileNamePChars), flag); //v2
                        //fCurEWFHandle:=fLibEWFOpen(fileNamePChars, Length(fileNamePChars), byte('r')); //v1
                        if LIBEWF_VERSION='V2' then
                          begin
                          ret:=flibewfhandleinitialize (@fCurEWFHandle,@err); //pointer to pointer = ** in c
                          if ret=1
                          then if flibewfhandleopen (fCurEWFHandle,fileNamePChars, Length(fileNamePChars), flag,@err)<>1
                            then {raise exception.Create('flibewfhandleopen failed')};
                          end;
                        if fCurEWFHandle<>nil then  Result:=0;


                end;
        finally
                FreeAndNil(filenames);
        end;
end;

{/*
  * Read an arbitrary part of the EWF file.
  * @param buffer : pointer - pointer to a preallocated buffer (byte array) to read into.
  * @param size - The number of bytes to read
  * @param offset - The position within the EWF file.
  * @return The number of bytes successfully read, -1 if unsuccessful.
  */}
function TLibEWF.libewf_read_buffer_at_offset(buffer : pointer; size : longword; offset : int64) : integer;
var
err:pointer;
begin
        err:=nil;
        Result:=-1;
        if fLibHandle<>0 then
        begin
        if LIBEWF_VERSION='V1' then Result:=fLibEWFReadRand(fCurEWFHandle, buffer, size, offset);
        if LIBEWF_VERSION='V2' then Result:=flibewfhandlereadbufferatoffset(fCurEWFHandle, buffer, size, offset,@err);
        end;
end;

{/*
  * write the buffer to a new EWF file.
  * @param handle : libEWF File Handle to write to
  * @param buffer : pointer - pointer to a preallocated buffer (byte array) to write from.
  * @param size - The number of bytes to write
  * @param offset - The position within the EWF file.
  * @return The number of bytes successfully written, -1 if unsuccessful.
  */}
function TLibEWF.libewf_write_buffer(Buffer : Pointer; size : longword) : integer;
var
  err:pointer;
  strError : string;
begin
  err:=nil;
  Result:=-1;
  if fLibHandle<>0 then
  begin
    if LIBEWF_VERSION='V2' then
    Result:=flibEWFhandlewritebuffer(fCurEWFHandle,
                                     buffer,
                                     size,
                                     @err);
  end;

  // This will throw a more specific error than generic system messages
  if result = -1 then
  begin
    SetLength(strError, 512);
    fLibEWFErrorSPrint(err, @strError[1], Length(strError));
    raise exception.Create (strError);
  end;

end;

// Used to read and then verify the newly created E01 file
function TLibEWF.libewf_handle_read_buffer(Buffer : Pointer; size : longword) : integer;
var
  err:pointer;
  strError : string;
begin
  err:=nil;
  Result:=-1;
  if fLibHandle<>0 then
  begin
    if LIBEWF_VERSION='V2' then
    Result:=flibEWFhandlereadbuffer(fCurEWFHandle,
                                    buffer,
                                    size,
                                    @err);
  end;

  // This will throw a more specific error than generic system messages
  if result = -1 then
  begin
    SetLength(strError, 512);
    fLibEWFErrorSPrint(err, @strError[1], Length(strError));
    raise exception.Create (strError);
  end;

end;

{/*
  * write an arbitrary part of the EWF file.
  * @param buffer : pointer - pointer to a preallocated buffer (byte array) to write from.
  * @param size - The number of bytes to write
  * @param offset - The position within the EWF file.
  * @return The number of bytes successfully written, -1 if unsuccessful.
  */}      
function TLibEWF.libewf_write_buffer_at_offset(buffer : pointer; size : longword; offset : int64) : integer;
var
err:pointer;
begin
        err:=nil;
        Result:=-1;
        if fLibHandle<>0 then
        begin
        if LIBEWF_VERSION='V1' then Result:=fLibEWFWriteRand(fCurEWFHandle, buffer, size, offset);
        if LIBEWF_VERSION='V2' then Result:=flibewfhandlewritebufferatoffset(fCurEWFHandle, buffer, size, offset,@err);
        end;
end;

{/*
  * set compression.
  * https://github.com/libyal/libewf/blob/54b0eada69defd015c49e4e1e1e4e26a27409ba3/libewf/libewf_definitions.h.in#L107
  * @param level : level 1=low using DEFLATE, 2=high using BZIP2, 0=none.
  * https://github.com/libyal/libewf/blob/54b0eada69defd015c49e4e1e1e4e26a27409ba3/libewf/libewf_definitions.h.in#L125
  * @param flags :
    * bit 1 set to 1 for empty block compression; detects empty blocks and
      stored them compressed, the compression is only done once
    * bit 2 set to 1 for pattern fill compression; this implies empty
      block compression using the pattern fill method. Bit 3-8 not used
  * @param flag - 0 tested ok
  * @return 1 success, -1 if unsuccessful.
  */}
function TLibEWF.libewf_SetCompressionValues(level,flags:byte) : integer;
var
err:pointer;
begin
        err:=nil;
        Result:=-1;
        if fLibHandle<>0 then
        begin
        //if LIBEWF_VERSION='V1' then ...;
        if LIBEWF_VERSION='V2' then Result:=flibewfhandlesetcompressionvalues (fCurEWFHandle, level, flags,@err);
        end;
end;

{/*
  * set value.
  * @param identifier
  * @param value
  * @return 1 success, -1 if unsuccessful
  */}
function TLibEWF.libewf_SetHeaderValue(identifier,value:ansistring) : integer;
var
err:pointer;
begin
        err:=nil;
        Result:=-1;
        if fLibHandle<>0 then
        begin
        //if LIBEWF_VERSION='V1' then ...;
        if LIBEWF_VERSION='V2' then Result:=flibewfhandlesetutf8headervalue (fCurEWFHandle, pansichar(identifier),length(identifier),pansichar(value),length(value),@err);
        end;
end;

{/*
  * get value.
  * @param identifier
  * @param value
  * @return 1 success, -1 if unsuccessful, 0 if not present
  */}
function TLibEWF.libewf_GetHeaderValue(identifier:ansistring;var value:ansistring) : integer;
var
err:pointer;
p:pansichar;
l:tsize;
begin
        err:=nil;
        Result:=-1;
        if fLibHandle<>0 then
        begin
        //if LIBEWF_VERSION='V1' then ...;
        getmem(p,255);
        if LIBEWF_VERSION='V2' then Result:=flibewfhandlegetutf8headervalue (fCurEWFHandle, pansichar(identifier),length(identifier),p,l,@err);
        if result=1 then value:=strpas(p);
        FreeMemory(p);
        end;
end;

{/*
  * get hash value.
  * @param identifier
  * @param value
  * @return 1 success, -1 if unsuccessful, 0 if not present
  */}
function TLibEWF.libewf_GetHashValue(identifier:ansistring;var value:ansistring) : integer;
var
err:pointer;
p:pansichar;
l:tsize;
begin
        err:=nil;
        Result:=-1;
        if fLibHandle<>0 then
        begin
        //if LIBEWF_VERSION='V1' then ...;
        getmem(p,255);
        if LIBEWF_VERSION='V2' then Result:=flibewfhandlegetutf8hashvalue (fCurEWFHandle, pansichar(identifier),length(identifier),p,l,@err);
        if result=1 then value:=strpas(p);
        FreeMemory(p);
        end;
end;

{/*
  * Get the total true size of the EWF file.
  * @return The size of the ewf file in bytes, -1 if unsuccessful.
  */}
function TLibEWF.libewf_get_media_size() : int64;
var
        resInt64 :Int64;
        err:pointer;
begin
        err:=nil;
        Result:=-1;
        resInt64:=-1;
        if (fLibHandle<>0) and (fCurEWFHandle<>nil) then
        begin
          if libewf_version='V1' then fLibEWFGetSize(fCurEWFHandle,@resInt64);
          if libewf_version='V2' then flibewfhandlegetmediasize (fCurEWFHandle,@resInt64,@err);
          Result:=resInt64;
          //Result:=fLibEWFGetSize(fCurEWFHandle); //v1
        end;
end;

{/*
  * Read and parse the header values of the EWF file.
  * @param date_format - Predefined date format required.
  * @return 0 if successful, -1 otherwise.
  */}
function TLibEWF.libewf_parse_header_values_deprecated(date_format : byte) : integer;
begin
        Result:=-1;
        if (fLibHandle<>0) and (fCurEWFHandle<>nil) then
        begin
                Result:=fLibEWFParseHdrVals(fCurEWFHandle, date_format);
        end;
end;

{/*
  * Close the EWF file.
  * @return 0 if successful, -1 otherwise.
  */}
function TLibEWF.libewf_close() : integer;
var
err:pointer;
begin
        err:=nil;
        if fLibHandle<>0 then
        begin
          if libewf_version='V1' then  Result:=fLibEWFClose(fCurEWFHandle);
          if libewf_version='V2' then
            begin
            Result:=flibewfhandleclose (fCurEWFHandle,@err);
            if result=0 then result:=flibewfhandlefree (@fCurEWFHandle,@err);
            end;
          fCurEWFHandle:=0;
        end;
end;

end.
 
