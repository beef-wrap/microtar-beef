using System;
using System.Diagnostics;
using static microtar.microtar;

namespace example;

class Program
{
	public static void Write()
	{
		String str1 = "Hello world";
		String str2 = "Goodbye world!!!";

		mtar_t tar;

		/* Open archive for writing */
		mtar_open(&tar, "test.tar", "w");

		/* Write strings to files `test1.txt` and `test2.txt` */
		mtar_write_file_header(&tar, "test1.txt", (.)str1.Length);
		mtar_write_data(&tar, str1, (.)str1.Length);

		mtar_write_file_header(&tar, "test2.txt", (.)str2.Length);
		mtar_write_data(&tar, str2, (.)str2.Length);

		/* Finalize -- this needs to be the last thing done before closing */
		mtar_finalize(&tar);

		/* Close archive */
		mtar_close(&tar);
	}

	public static void Read()
	{
		mtar_t tar;
		mtar_header_t h = .();
		char8* p;

		/* Open archive for reading */
		mtar_open(&tar, "test.tar", "r");

		/* Print all file names and sizes */
		while ((mtar_read_header(&tar, &h)) != .MTAR_ENULLRECORD)
		{
			Debug.WriteLine($"{StringView(&h.name)} ({h.size} bytes)");
			mtar_next(&tar);
		}

		/* Load and print contents of file "test.txt" */
		mtar_find(&tar, "test1.txt", &h);
		p = (char8*)Internal.Malloc(h.size);
		mtar_read_data(&tar, p, h.size);
		Debug.WriteLine(StringView(p, h.size));
		Internal.Free(p);

		/* Close archive */
		mtar_close(&tar);
	}

	public static int Main(String[] args)
	{
		Write();
		Read();
		return 0;
	}
}