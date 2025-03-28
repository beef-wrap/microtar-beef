/**
 * Copyright (c) 2017 rxi
 *
 * This library is free software; you can redistribute it and/or modify it
 * under the terms of the MIT license. See `microtar.c` for details.
 */

using System;
using System.Interop;

namespace microtar;

public static class microtar
{
	typealias char = char8;
	
	public const String MTAR_VERSION = "0.1.0";

	public enum mt_result : c_int
	{
		MTAR_ESUCCESS     =  0,
		MTAR_EFAILURE     = -1,
		MTAR_EOPENFAIL    = -2,
		MTAR_EREADFAIL    = -3,
		MTAR_EWRITEFAIL   = -4,
		MTAR_ESEEKFAIL    = -5,
		MTAR_EBADCHKSUM   = -6,
		MTAR_ENULLRECORD  = -7,
		MTAR_ENOTFOUND    = -8
	}

	public enum mt_code : c_int
	{
		MTAR_TREG   = '0',
		MTAR_TLNK   = '1',
		MTAR_TSYM   = '2',
		MTAR_TCHR   = '3',
		MTAR_TBLK   = '4',
		MTAR_TDIR   = '5',
		MTAR_TFIFO  = '6'
	}

	[CRepr]
	public struct mtar_header_t
	{
		public c_uint mode;
		public c_uint owner;
		public c_uint size;
		public c_uint mtime;
		public c_uint type;
		public char[100] name;
		public char[100] linkname;
	}

	[CRepr]
	public struct mtar_t
	{
		public function c_int (mtar_t* tar, void* data, c_uint size) read;
		public function c_int (mtar_t* tar, void* data, c_uint size) write;
		public function c_int (mtar_t* tar, c_uint pos) seek;
		public function c_int (mtar_t* tar) close;
		public void* stream;
		public c_uint pos;
		public c_uint remaining_data;
		public c_uint last_header;
	}

	[CLink] public static extern char* mtar_strerror(c_int err);

	[CLink] public static extern c_int mtar_open(mtar_t* tar, char* filename, char* mode);
	[CLink] public static extern c_int mtar_close(mtar_t* tar);

	[CLink] public static extern c_int mtar_seek(mtar_t* tar, c_uint pos);
	[CLink] public static extern c_int mtar_rewind(mtar_t* tar);
	[CLink] public static extern c_int mtar_next(mtar_t* tar);
	[CLink] public static extern c_int mtar_find(mtar_t* tar, char* name, mtar_header_t* h);
	[CLink] public static extern mt_result mtar_read_header(mtar_t* tar, mtar_header_t* h);
	[CLink] public static extern c_int mtar_read_data(mtar_t* tar, void* ptr, c_uint size);

	[CLink] public static extern c_int mtar_write_header(mtar_t* tar, mtar_header_t* h);
	[CLink] public static extern c_int mtar_write_file_header(mtar_t* tar, char* name, c_uint size);
	[CLink] public static extern c_int mtar_write_dir_header(mtar_t* tar, char* name);
	[CLink] public static extern c_int mtar_write_data(mtar_t* tar, void* data, c_uint size);
	[CLink] public static extern c_int mtar_finalize(mtar_t* tar);
}