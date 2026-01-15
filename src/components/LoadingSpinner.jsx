import React from 'react';

export default function LoadingSpinner() {
  return (
    <div
      className='absolute top-1/2 left-1/2 w-6 h-6 sm:w-8 sm:h-8 md:w-10 md:h-10 border-4 border-[#ae2b2b] border-t-transparent rounded-full animate-spin'
    ></div>
  );
};