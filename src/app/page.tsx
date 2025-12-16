export default function Home() {
  return (
    <div className="bg-black min-h-screen flex flex-col items-center justify-center">
      <h1 className="text-[300px] text-white font-bold">Welcome!</h1>
      <p className="w-3xl text-center text-zinc-600 text-lg text-pretty">
        Lorem Ipsum is simply dummy text of the printing and typesetting
        industry. Lorem Ipsum has been the industrys standard dummy text ever
        since the 1500s, when an unknown printer took a galley of type and
        scrambled it to make a type specimen book. It has survived not only five
        centuries, but also the leap into electronic typesetting, remaining
        essentially unchanged. It was popularised in the 1960s with the release
      </p>
      <button className="mt-6 text-black bg-white py-2 px-4 rounded-xl cursor-pointer hover:bg-gray-200 transition">
        Learn more
      </button>
    </div>
  );
}
