# Assignment 2

This Python program is a custom network traffic analyzer (often referred to as a custom subset of Wireshark or tcpdump). It reads raw binary packet capture files (typically .cap or .pcap) from the command line, extracts network layer details, tracks conversation streams, and prints out complex connection metrics.
Here is a breakdown of what the code does:

### 1. Binary Packet Ingestion (read_packets)
The program opens the network trace file in binary mode and decodes its structured headers using Python's struct library.
- It identifies the file's endianness (byte-order) via a header magic number.
- It iterates through individual packets, stripping away global headers to extract each packet's precise timestamp and raw data payload.
- It establishes a relative timeline by setting the first packet's timestamp as time $0.0$.

### 2. Deep Packet Inspection Layers
The code includes a custom network stack parser that breaks down each packet header-by-header:
- parse_ethernet: Extracts the Ethernet layer, verifying that the payload encapsulates an IPv4 protocol ($0x0800$).
- parse_ip: Parses the IPv4 header layer, converting raw binary network addresses into standard string IP notation (e.g., 192.168.1.1), identifying the internal transmission protocol, and slicing out the layer data. It drops everything that isn't a TCP segment (Protocol 6).
- parse_tcp: Drills into the TCP transmission block to isolate metadata fields: source/destination ports, Sequence numbers (seq), Acknowledgment numbers (ack_seq), sliding window sizes, data lengths, and active structural TCP flag markers (SYN, ACK, FIN, RST).

### 3. Session Stream Tracking (Connection Class)
Instead of treating packets as isolated events, the script groups them into bidirectional network streams using a 4-tuple unique key: (Source IP, Source Port, Destination IP, Destination Port).
The program instantiates a state-tracking class to update session logs dynamically:
- Tracks directional metrics (counting forward vs. reverse packet counts and raw data byte volumes).
- Logs window size variations over time.
- Evaluates connection states (OPEN, COMPLETE, RESET, or ESTABLISHED BEFORE CAPTURE) based on handshake flag occurrences.
- RTT Computation: Calculates Round-Trip Time (RTT) during the initial 3-way handshake by measuring the precise time delta between seeing the original forward SYN packet and its matching reverse SYN-ACK reply.

### 4. Analytical Summary Output
Once the entire capture file is fully traversed, the program calculates statistics using Python's statistics module and prints a multi-part diagnostic report directly to the command line:
- Section A & B (Inventory): Displays the total connection count followed by explicit tracking sheets for each individual stream (IPs, ports, session duration, directional packet splits, and overall data transfer sizes).
- Section C (General Breakdown): Summarizes structural tallies across the whole capture file, isolating closed cycles, forced aborts (RESET), legacy pipes left open, and streams that began before the monitor started recording.
- Section D (Global Averages): Aggregates math across all fully completed conversations to display the minimum, mean, and maximum values for connection durations, RTT intervals, total packet counts, and network window capacity frames.
